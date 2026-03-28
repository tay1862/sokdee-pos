package models

import "time"

// ─── Subscription Plan ────────────────────────────────────────────────────────

type PlanFeatures struct {
	KDS               bool `json:"kds"`
	AdvancedReports   bool `json:"advanced_reports"`
	Inventory         bool `json:"inventory"`
	MultiCurrency     bool `json:"multi_currency"`
	TableManagement   bool `json:"table_management"`
	MaxUsers          *int `json:"max_users"`    // nil = unlimited
	MaxProducts       *int `json:"max_products"` // nil = unlimited
}

type SubscriptionPlan struct {
	ID          string       `json:"id"`
	Name        string       `json:"name"`
	MaxUsers    *int         `json:"max_users"`
	MaxProducts *int         `json:"max_products"`
	Features    PlanFeatures `json:"features"`
	CreatedAt   time.Time    `json:"created_at"`
}

func (p *SubscriptionPlan) HasFeature(feature string) bool {
	switch feature {
	case "kds":
		return p.Features.KDS
	case "advanced_reports":
		return p.Features.AdvancedReports
	case "inventory":
		return p.Features.Inventory
	case "multi_currency":
		return p.Features.MultiCurrency
	case "table_management":
		return p.Features.TableManagement
	default:
		return false
	}
}

// ─── Tenant ───────────────────────────────────────────────────────────────────

type Tenant struct {
	ID            string    `json:"id"`
	Name          string    `json:"name"`
	StoreType     string    `json:"store_type"`
	PlanID        *string   `json:"plan_id"`
	Status        string    `json:"status"`
	DefaultLang   string    `json:"default_lang"`
	BaseCurrency  string    `json:"base_currency"`
	CreatedAt     time.Time `json:"created_at"`
	ExpiresAt     *time.Time `json:"expires_at"`
}

// ─── User ─────────────────────────────────────────────────────────────────────

type User struct {
	ID                 string     `json:"id"`
	TenantID           string     `json:"tenant_id"`
	Username           string     `json:"username"`
	DisplayName        string     `json:"display_name"`
	Role               string     `json:"role"`
	IsActive           bool       `json:"is_active"`
	FailedPinAttempts  int        `json:"-"`
	LockedUntil        *time.Time `json:"-"`
	CreatedAt          time.Time  `json:"created_at"`
}

// Role constants
const (
	RoleSuperAdmin   = "super_admin"
	RoleOwner        = "owner"
	RoleManager      = "manager"
	RoleCashier      = "cashier"
	RoleKitchenStaff = "kitchen_staff"
)

// RoleLevel returns numeric level for comparison (higher = more permissions)
func RoleLevel(role string) int {
	switch role {
	case RoleSuperAdmin:
		return 5
	case RoleOwner:
		return 4
	case RoleManager:
		return 3
	case RoleCashier:
		return 2
	case RoleKitchenStaff:
		return 1
	default:
		return 0
	}
}

// ─── JWT Claims ───────────────────────────────────────────────────────────────

type JWTClaims struct {
	Sub      string `json:"sub"`
	TenantID string `json:"tenant_id"`
	Role     string `json:"role"`
	DeviceID string `json:"device_id"`
}

// ─── Store Types ──────────────────────────────────────────────────────────────

const (
	StoreTypeRestaurant = "restaurant"
	StoreTypeRetail     = "retail"
	StoreTypeWarehouse  = "warehouse"
	StoreTypeAutoParts  = "auto_parts"
	StoreTypeOther      = "other"
)

// ─── Order ────────────────────────────────────────────────────────────────────

type Order struct {
	ID             string     `json:"id"`
	TenantID       string     `json:"tenant_id"`
	OrderNumber    string     `json:"order_number"`
	TableID        *string    `json:"table_id"`
	CashierID      string     `json:"cashier_id"`
	ShiftID        *string    `json:"shift_id"`
	Status         string     `json:"status"`
	Subtotal       float64    `json:"subtotal"`
	DiscountAmount float64    `json:"discount_amount"`
	TaxAmount      float64    `json:"tax_amount"`
	Total          float64    `json:"total"`
	Notes          *string    `json:"notes"`
	CreatedAt      time.Time  `json:"created_at"`
	PaidAt         *time.Time `json:"paid_at"`
}

// Order status constants
const (
	OrderStatusOpen     = "open"
	OrderStatusPaid     = "paid"
	OrderStatusVoided   = "voided"
	OrderStatusRefunded = "refunded"
)

// ─── Payment ──────────────────────────────────────────────────────────────────

type Payment struct {
	ID           string    `json:"id"`
	OrderID      string    `json:"order_id"`
	TenantID     string    `json:"tenant_id"`
	Method       string    `json:"method"`
	Currency     string    `json:"currency"`
	Amount       float64   `json:"amount"`
	AmountLAK    float64   `json:"amount_lak"`
	ExchangeRate float64   `json:"exchange_rate"`
	ChangeAmount float64   `json:"change_amount"`
	CreatedAt    time.Time `json:"created_at"`
}

// Payment method constants
const (
	PaymentMethodCash     = "cash"
	PaymentMethodQR       = "qr"
	PaymentMethodTransfer = "transfer"
)

// Currency constants
const (
	CurrencyLAK = "LAK"
	CurrencyTHB = "THB"
	CurrencyUSD = "USD"
)
