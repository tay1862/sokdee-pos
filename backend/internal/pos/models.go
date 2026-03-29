package pos

import "time"

// OrderItem is a line item in an order
type OrderItem struct {
	ID          string   `json:"id"`
	OrderID     string   `json:"order_id"`
	TenantID    string   `json:"tenant_id"`
	ProductID   string   `json:"product_id"`
	VariantID   *string  `json:"variant_id"`
	ProductName string   `json:"product_name"`
	UnitPrice   float64  `json:"unit_price"`
	Quantity    int      `json:"quantity"`
	Discount    float64  `json:"discount"`
	LineTotal   float64  `json:"line_total"`
	Modifiers   []string `json:"modifiers"`
	Notes       *string  `json:"notes"`
	KDSStatus   string   `json:"kds_status"`
}

// Order represents a sales transaction
type Order struct {
	ID             string      `json:"id"`
	TenantID       string      `json:"tenant_id"`
	OrderNumber    string      `json:"order_number"`
	TableID        *string     `json:"table_id"`
	CashierID      string      `json:"cashier_id"`
	ShiftID        *string     `json:"shift_id"`
	Status         string      `json:"status"`
	Subtotal       float64     `json:"subtotal"`
	DiscountAmount float64     `json:"discount_amount"`
	TaxAmount      float64     `json:"tax_amount"`
	Total          float64     `json:"total"`
	Notes          *string     `json:"notes"`
	IdempotencyKey *string     `json:"idempotency_key,omitempty"`
	Items          []OrderItem `json:"items"`
	CreatedAt      time.Time   `json:"created_at"`
	PaidAt         *time.Time  `json:"paid_at"`
}

// PaymentRequest holds payment details from the client
type PaymentRequest struct {
	Payments []PaymentLine `json:"payments"`
}

// PaymentLine is one payment method in a split payment
type PaymentLine struct {
	Method       string  `json:"method"`   // cash, qr, transfer
	Currency     string  `json:"currency"` // LAK, THB, USD
	Amount       float64 `json:"amount"`
	ExchangeRate float64 `json:"exchange_rate"`
}

// VoidRequest holds void details
type VoidRequest struct {
	Reason string `json:"reason"`
}

// RefundRequest holds refund details
type RefundRequest struct {
	Reason     string        `json:"reason"`
	ApprovedBy string        `json:"approved_by"` // user ID of approver
	Items      []RefundItem  `json:"items"`
}

// RefundItem specifies which items to refund
type RefundItem struct {
	OrderItemID string `json:"order_item_id"`
	Quantity    int    `json:"quantity"`
}
