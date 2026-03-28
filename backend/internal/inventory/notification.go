package inventory

import (
	"context"
	"log"
)

// NotificationService sends low-stock alerts
type NotificationService struct {
	repo     Repository
	notifyer Notifyer
}

// Notifyer creates in-app notifications
type Notifyer interface {
	CreateNotification(ctx context.Context, tenantID, userRole, title, body string) error
}

// NewNotificationService creates a notification service
func NewNotificationService(repo Repository, n Notifyer) *NotificationService {
	return &NotificationService{repo: repo, notifyer: n}
}

// CheckLowStock checks stock after a transaction and fires notifications if needed
func (s *NotificationService) CheckLowStock(ctx context.Context, tenantID, productID string, variantID *string) {
	product, err := s.repo.GetProduct(ctx, tenantID, productID)
	if err != nil || product == nil {
		return
	}

	stock, err := s.repo.GetCurrentStock(ctx, tenantID, productID, variantID)
	if err != nil {
		return
	}

	if stock <= product.MinStock {
		title := "Low Stock Alert"
		body := product.Name + " is running low (" + itoa(stock) + " remaining)"

		for _, role := range []string{"owner", "manager"} {
			if err := s.notifyer.CreateNotification(ctx, tenantID, role, title, body); err != nil {
				log.Printf("notification error: %v", err)
			}
		}
	}
}

func itoa(n int) string {
	if n == 0 {
		return "0"
	}
	result := ""
	neg := n < 0
	if neg {
		n = -n
	}
	for n > 0 {
		result = string(rune('0'+n%10)) + result
		n /= 10
	}
	if neg {
		result = "-" + result
	}
	return result
}
