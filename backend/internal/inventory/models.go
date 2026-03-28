package inventory

import "time"

// Category represents a product category
type Category struct {
	ID        string     `json:"id"`
	TenantID  string     `json:"tenant_id"`
	ParentID  *string    `json:"parent_id"`
	Name      string     `json:"name"`
	SortOrder int        `json:"sort_order"`
	IsActive  bool       `json:"is_active"`
	UpdatedAt time.Time  `json:"updated_at"`
}

// Product represents a sellable item
type Product struct {
	ID          string    `json:"id"`
	TenantID    string    `json:"tenant_id"`
	Name        string    `json:"name"`
	Description *string   `json:"description"`
	Barcode     *string   `json:"barcode"`
	SellPrice   float64   `json:"sell_price"`
	CostPrice   *float64  `json:"cost_price"`
	Unit        *string   `json:"unit"`
	MinStock    int       `json:"min_stock"`
	IsActive    bool      `json:"is_active"`
	HasVariants bool      `json:"has_variants"`
	Categories  []string  `json:"category_ids"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
}

// ProductVariant represents a variant of a product (size, color, etc.)
type ProductVariant struct {
	ID        string   `json:"id"`
	ProductID string   `json:"product_id"`
	TenantID  string   `json:"tenant_id"`
	Name      string   `json:"name"`
	Barcode   *string  `json:"barcode"`
	SellPrice *float64 `json:"sell_price"`
	CostPrice *float64 `json:"cost_price"`
	StockQty  int      `json:"stock_qty"`
}

// ProductModifier represents a modifier group for restaurant menus
type ProductModifier struct {
	ID         string   `json:"id"`
	TenantID   string   `json:"tenant_id"`
	ProductID  string   `json:"product_id"`
	Name       string   `json:"name"`
	Options    []string `json:"options"`
	IsRequired bool     `json:"is_required"`
}

// StockTransaction records every stock movement
type StockTransaction struct {
	ID          string    `json:"id"`
	TenantID    string    `json:"tenant_id"`
	ProductID   string    `json:"product_id"`
	VariantID   *string   `json:"variant_id"`
	Type        string    `json:"type"` // sale, stock_in, adjustment, refund, void
	Quantity    int       `json:"quantity"`
	CostPrice   *float64  `json:"cost_price"`
	Reason      *string   `json:"reason"`
	ReferenceID *string   `json:"reference_id"`
	PerformedBy string    `json:"performed_by"`
	CreatedAt   time.Time `json:"created_at"`
}
