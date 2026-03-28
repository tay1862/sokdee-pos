package auth

import (
	"context"
	"time"
)

const (
	MaxFailedAttempts = 5
	LockoutDuration   = 15 * time.Minute
)

// LockoutService handles PIN lockout logic
type LockoutService struct {
	repo LockoutRepository
}

// LockoutRepository defines the data access needed for lockout
type LockoutRepository interface {
	IncrementFailedAttempts(ctx context.Context, userID string) (int, error)
	ResetFailedAttempts(ctx context.Context, userID string) error
	LockUser(ctx context.Context, userID string, until time.Time) error
	GetFailedAttempts(ctx context.Context, userID string) (int, *time.Time, error)
}

// NewLockoutService creates a new lockout service
func NewLockoutService(repo LockoutRepository) *LockoutService {
	return &LockoutService{repo: repo}
}

// IsLocked returns true if the user is currently locked out
func (s *LockoutService) IsLocked(ctx context.Context, userID string) (bool, *time.Time, error) {
	_, lockedUntil, err := s.repo.GetFailedAttempts(ctx, userID)
	if err != nil {
		return false, nil, err
	}
	if lockedUntil != nil && lockedUntil.After(time.Now()) {
		return true, lockedUntil, nil
	}
	return false, nil, nil
}

// RecordFailure increments failed attempts and locks the account if threshold reached.
// Returns the new attempt count and whether the account was just locked.
func (s *LockoutService) RecordFailure(ctx context.Context, userID string) (attempts int, locked bool, err error) {
	attempts, err = s.repo.IncrementFailedAttempts(ctx, userID)
	if err != nil {
		return 0, false, err
	}

	if attempts >= MaxFailedAttempts {
		lockUntil := time.Now().Add(LockoutDuration)
		if lockErr := s.repo.LockUser(ctx, userID, lockUntil); lockErr != nil {
			return attempts, false, lockErr
		}
		return attempts, true, nil
	}

	return attempts, false, nil
}

// RecordSuccess resets the failed attempt counter after a successful login
func (s *LockoutService) RecordSuccess(ctx context.Context, userID string) error {
	return s.repo.ResetFailedAttempts(ctx, userID)
}
