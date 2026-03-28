package inventory

import "context"

// Repository defines data access for inventory
type Repository interface {
	// Categories
	ListCategories(ctx context.Context, tenantID string) ([]*Category, error)
	CreateCategory(ctx context.Context, cat *Category) error
	UpdateCategory(ctx context.Context, cat *Category) error
	DeleteCategory(ctx context.Context, tenantID, id string) error

	// Products
	ListProducts(ctx context.Context, tenantID string, activeOnly bool) ([]*Product, error)
	GetProduct(ctx context.Context, tenantID, id string) (*Product, error)
	GetProductByBarcode(ctx context.Context, tenantID, barcode string) (*Product, error)
	CreateProduct(ctx context.Context, p *Product) error
	UpdateProduct(ctx context.Context, p *Product) error
	DeleteProduct(ctx context.Context, tenantID, id string) error
	CountProducts(ctx context.Context, tenantID string) (int, error)
	BulkCreateProducts(ctx context.Context, products []*Product) error

	// Variants
	ListVariants(ctx context.Context, productID string) ([]*ProductVariant, error)
	CreateVariant(ctx context.Context, v *ProductVariant) error
	UpdateVariant(ctx context.Context, v *ProductVariant) error
	DeleteVariant(ctx context.Context, tenantID, id string) error

	// Stock
	CreateStockTransaction(ctx context.Context, tx *StockTransaction) error
	ListStockTransactions(ctx context.Context, tenantID, productID string) ([]*StockTransaction, error)
	GetCurrentStock(ctx context.Context, tenantID, productID string, variantID *string) (int, error)
	DeductStock(ctx context.Context, tenantID, productID string, variantID *string, qty int, refID string) error
	RestoreStock(ctx context.Context, tenantID, productID string, variantID *string, qty int, refID string) error
}
