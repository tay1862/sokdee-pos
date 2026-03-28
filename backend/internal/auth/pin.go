package auth

import (
	"errors"
	"regexp"

	"golang.org/x/crypto/bcrypt"
)

const bcryptCost = 12

var (
	ErrInvalidPINFormat = errors.New("PIN must be 4-6 digits")
	ErrPINMismatch      = errors.New("PIN does not match")

	pinRegex = regexp.MustCompile(`^\d{4,6}$`)
)

// ValidatePIN checks that a PIN is 4-6 numeric digits
func ValidatePIN(pin string) error {
	if !pinRegex.MatchString(pin) {
		return ErrInvalidPINFormat
	}
	return nil
}

// HashPIN hashes a PIN using bcrypt with cost 12
func HashPIN(pin string) (string, error) {
	if err := ValidatePIN(pin); err != nil {
		return "", err
	}
	hash, err := bcrypt.GenerateFromPassword([]byte(pin), bcryptCost)
	if err != nil {
		return "", err
	}
	return string(hash), nil
}

// VerifyPIN compares a plain PIN against a bcrypt hash
func VerifyPIN(pin, hash string) bool {
	return bcrypt.CompareHashAndPassword([]byte(hash), []byte(pin)) == nil
}
