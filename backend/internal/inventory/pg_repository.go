package inventory

import (
	"context"
	"encoding/csv"
	"errors"
	"io"
	"strconv"
	"strings"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
)

// PgRepository implements Repository using PostgreSQL
type PgRepository struct{ db *pgxpool.Pool }

func NewPgRepository(db *pgxpool.Pool) *PgRepository { return &PgRepository{db: db} }

// ─── Categories ───────────────────────────────────────────────────────────────

func (r *PgRepository) ListCategories(ctx context.Context, tenantID string) ([]*Category, error) {
	rows, err := r.db.Query(ctx,
		`SELECT id, tenant_id, parent_id, name, sort_order, is_active
		 FROM categories WHERE tenant_id=$1 ORDER BY sort_order, name`, tenantID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var cats []*Category
	for rows.Next() {
		var c Category
		if err := rows.Scan(&c.ID, &c.TenantID, &c.ParentID, &c.Name, &c.SortOrder, &c.IsActive); err != nil {
			return nil, err
		}
		cats = append(cats, &c)
	}
	return cats, nil
}

func (r *PgRepository) CreateCategory(ctx context.Context, cat *Category) error {
	return r.db.QueryRow(ctx,
		`INSERT INTO categories (tenant_id, parent_id, name, sort_order)
		 VALUES ($1, $2, $3, $4) RETURNING id`,
		cat.TenantID, cat.ParentID, cat.Name, cat.SortOrder,
	).Scan(&cat.ID)
}

func (r *PgRepository) UpdateCategory(ctx context.Context, cat *Category) error {
	_, err := r.db.Exec(ctx,
		`UPDATE categories SET name=$1, sort_order=$2, is_active=$3, updated_at=NOW()
		 WHERE id=$4 AND tenant_id=$5`,
		cat.Name, cat.SortOrder, cat.IsActive, cat.ID, cat.TenantID)
	return err
}

func (r *PgRepository) DeleteCategory(ctx context.Context, tenantID, id string) error {
	_, err := r.db.Exec(ctx, `DELETE FROM categories WHERE id=$1 AND tenant_id=$2`, id, tenantID)
	return err
}

// ─── Products ─────────────────────────────────────────────────────────────────

func (r *PgRepository) ListProducts(ctx context.Context, tenantID string, activeOnly bool) ([]*Product, error) {
	q := `SELECT p.id, p.tenant_id, p.name, p.description, p.barcode,
		         p.sell_price, p.cost_price, p.unit, p.min_stock, p.is_active, p.has_variants,
		         COALESCE(SUM(st.quantity), 0) as stock_qty
		  FROM products p
		  LEFT JOIN stock_transactions st ON st.product_id=p.id AND st.variant_id IS NULL
		  WHERE p.tenant_id=$1`
	if activeOnly {
		q += " AND p.is_active=true"
	}
	q += " GROUP BY p.id ORDER BY p.name"

	rows, err := r.db.Query(ctx, q, tenantID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var products []*Product
	for rows.Next() {
		var p Product
		var stockQty int
		if err := rows.Scan(&p.ID, &p.TenantID, &p.Name, &p.Description, &p.Barcode,
			&p.SellPrice, &p.CostPrice, &p.Unit, &p.MinStock, &p.IsActive, &p.HasVariants,
			&stockQty); err != nil {
			return nil, err
		}
		products = append(products, &p)
	}
	return products, nil
}

func (r *PgRepository) GetProduct(ctx context.Context, tenantID, id string) (*Product, error) {
	var p Product
	err := r.db.QueryRow(ctx,
		`SELECT id, tenant_id, name, description, barcode, sell_price, cost_price,
		        unit, min_stock, is_active, has_variants
		 FROM products WHERE id=$1 AND tenant_id=$2`, id, tenantID,
	).Scan(&p.ID, &p.TenantID, &p.Name, &p.Description, &p.Barcode,
		&p.SellPrice, &p.CostPrice, &p.Unit, &p.MinStock, &p.IsActive, &p.HasVariants)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, nil
	}
	return &p, err
}

func (r *PgRepository) GetProductByBarcode(ctx context.Context, tenantID, barcode string) (*Product, error) {
	var p Product
	err := r.db.QueryRow(ctx,
		`SELECT id, tenant_id, name, description, barcode, sell_price, cost_price,
		        unit, min_stock, is_active, has_variants
		 FROM products WHERE tenant_id=$1 AND barcode=$2 AND is_active=true`,
		tenantID, barcode,
	).Scan(&p.ID, &p.TenantID, &p.Name, &p.Description, &p.Barcode,
		&p.SellPrice, &p.CostPrice, &p.Unit, &p.MinStock, &p.IsActive, &p.HasVariants)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, nil
	}
	return &p, err
}

func (r *PgRepository) CreateProduct(ctx context.Context, p *Product) error {
	return r.db.QueryRow(ctx,
		`INSERT INTO products (tenant_id, name, description, barcode, sell_price, cost_price, unit, min_stock)
		 VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING id, created_at, updated_at`,
		p.TenantID, p.Name, p.Description, p.Barcode, p.SellPrice, p.CostPrice, p.Unit, p.MinStock,
	).Scan(&p.ID, &p.CreatedAt, &p.UpdatedAt)
}

func (r *PgRepository) UpdateProduct(ctx context.Context, p *Product) error {
	_, err := r.db.Exec(ctx,
		`UPDATE products SET name=$1, description=$2, barcode=$3, sell_price=$4,
		        cost_price=$5, unit=$6, min_stock=$7, is_active=$8, updated_at=NOW()
		 WHERE id=$9 AND tenant_id=$10`,
		p.Name, p.Description, p.Barcode, p.SellPrice, p.CostPrice,
		p.Unit, p.MinStock, p.IsActive, p.ID, p.TenantID)
	return err
}

func (r *PgRepository) DeleteProduct(ctx context.Context, tenantID, id string) error {
	_, err := r.db.Exec(ctx,
		`UPDATE products SET is_active=false, updated_at=NOW() WHERE id=$1 AND tenant_id=$2`,
		id, tenantID)
	return err
}

func (r *PgRepository) CountProducts(ctx context.Context, tenantID string) (int, error) {
	var count int
	err := r.db.QueryRow(ctx,
		`SELECT COUNT(*) FROM products WHERE tenant_id=$1 AND is_active=true`, tenantID,
	).Scan(&count)
	return count, err
}

func (r *PgRepository) BulkCreateProducts(ctx context.Context, products []*Product) error {
	tx, err := r.db.Begin(ctx)
	if err != nil {
		return err
	}
	defer tx.Rollback(ctx)

	for _, p := range products {
		if err := r.db.QueryRow(ctx,
			`INSERT INTO products (tenant_id, name, sell_price, cost_price, barcode, unit, is_active)
			 VALUES ($1, $2, $3, $4, $5, $6, true) RETURNING id`,
			p.TenantID, p.Name, p.SellPrice, p.CostPrice, p.Barcode, p.Unit,
		).Scan(&p.ID); err != nil {
			return err
		}
	}
	return tx.Commit(ctx)
}

// ParseCSV parses a CSV reader into Product slices (helper for handler)
func ParseCSV(r io.Reader, tenantID string) ([]*Product, error) {
	reader := csv.NewReader(r)
	records, err := reader.ReadAll()
	if err != nil {
		return nil, err
	}
	if len(records) < 2 {
		return nil, nil
	}
	var products []*Product
	for _, row := range records[1:] {
		if len(row) < 2 {
			continue
		}
		price, _ := strconv.ParseFloat(strings.TrimSpace(row[1]), 64)
		p := &Product{TenantID: tenantID, Name: strings.TrimSpace(row[0]), SellPrice: price, IsActive: true}
		if len(row) > 2 {
			cp, _ := strconv.ParseFloat(strings.TrimSpace(row[2]), 64)
			p.CostPrice = &cp
		}
		if len(row) > 3 && row[3] != "" {
			bc := strings.TrimSpace(row[3])
			p.Barcode = &bc
		}
		if len(row) > 4 && row[4] != "" {
			u := strings.TrimSpace(row[4])
			p.Unit = &u
		}
		products = append(products, p)
	}
	return products, nil
}

// ─── Variants ─────────────────────────────────────────────────────────────────

func (r *PgRepository) ListVariants(ctx context.Context, productID string) ([]*ProductVariant, error) {
	rows, err := r.db.Query(ctx,
		`SELECT id, product_id, tenant_id, name, barcode, sell_price, cost_price, stock_qty
		 FROM product_variants WHERE product_id=$1`, productID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var variants []*ProductVariant
	for rows.Next() {
		var v ProductVariant
		if err := rows.Scan(&v.ID, &v.ProductID, &v.TenantID, &v.Name, &v.Barcode,
			&v.SellPrice, &v.CostPrice, &v.StockQty); err != nil {
			return nil, err
		}
		variants = append(variants, &v)
	}
	return variants, nil
}

func (r *PgRepository) CreateVariant(ctx context.Context, v *ProductVariant) error {
	return r.db.QueryRow(ctx,
		`INSERT INTO product_variants (product_id, tenant_id, name, barcode, sell_price, cost_price, stock_qty)
		 VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING id`,
		v.ProductID, v.TenantID, v.Name, v.Barcode, v.SellPrice, v.CostPrice, v.StockQty,
	).Scan(&v.ID)
}

func (r *PgRepository) UpdateVariant(ctx context.Context, v *ProductVariant) error {
	_, err := r.db.Exec(ctx,
		`UPDATE product_variants SET name=$1, barcode=$2, sell_price=$3, cost_price=$4, updated_at=NOW()
		 WHERE id=$5 AND tenant_id=$6`,
		v.Name, v.Barcode, v.SellPrice, v.CostPrice, v.ID, v.TenantID)
	return err
}

func (r *PgRepository) DeleteVariant(ctx context.Context, tenantID, id string) error {
	_, err := r.db.Exec(ctx, `DELETE FROM product_variants WHERE id=$1 AND tenant_id=$2`, id, tenantID)
	return err
}

// ─── Stock ────────────────────────────────────────────────────────────────────

func (r *PgRepository) CreateStockTransaction(ctx context.Context, tx *StockTransaction) error {
	return r.db.QueryRow(ctx,
		`INSERT INTO stock_transactions (tenant_id, product_id, variant_id, type, quantity, cost_price, reason, reference_id, performed_by)
		 VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING id, created_at`,
		tx.TenantID, tx.ProductID, tx.VariantID, tx.Type, tx.Quantity,
		tx.CostPrice, tx.Reason, tx.ReferenceID, tx.PerformedBy,
	).Scan(&tx.ID, &tx.CreatedAt)
}

func (r *PgRepository) ListStockTransactions(ctx context.Context, tenantID, productID string) ([]*StockTransaction, error) {
	q := `SELECT id, tenant_id, product_id, variant_id, type, quantity, cost_price, reason, reference_id, performed_by, created_at
		  FROM stock_transactions WHERE tenant_id=$1`
	args := []any{tenantID}
	if productID != "" {
		q += " AND product_id=$2"
		args = append(args, productID)
	}
	q += " ORDER BY created_at DESC LIMIT 100"

	rows, err := r.db.Query(ctx, q, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var txs []*StockTransaction
	for rows.Next() {
		var t StockTransaction
		if err := rows.Scan(&t.ID, &t.TenantID, &t.ProductID, &t.VariantID, &t.Type,
			&t.Quantity, &t.CostPrice, &t.Reason, &t.ReferenceID, &t.PerformedBy, &t.CreatedAt); err != nil {
			return nil, err
		}
		txs = append(txs, &t)
	}
	return txs, nil
}

func (r *PgRepository) GetCurrentStock(ctx context.Context, tenantID, productID string, variantID *string) (int, error) {
	var stock int
	var err error
	if variantID != nil {
		err = r.db.QueryRow(ctx,
			`SELECT COALESCE(SUM(quantity), 0) FROM stock_transactions
			 WHERE tenant_id=$1 AND product_id=$2 AND variant_id=$3`,
			tenantID, productID, *variantID,
		).Scan(&stock)
	} else {
		err = r.db.QueryRow(ctx,
			`SELECT COALESCE(SUM(quantity), 0) FROM stock_transactions
			 WHERE tenant_id=$1 AND product_id=$2 AND variant_id IS NULL`,
			tenantID, productID,
		).Scan(&stock)
	}
	return stock, err
}

func (r *PgRepository) DeductStock(ctx context.Context, tenantID, productID string, variantID *string, qty int, refID string) error {
	_, err := r.db.Exec(ctx,
		`INSERT INTO stock_transactions (tenant_id, product_id, variant_id, type, quantity, reference_id, performed_by)
		 VALUES ($1, $2, $3, 'sale', $4, $5, 'system')`,
		tenantID, productID, variantID, -qty, refID)
	return err
}

func (r *PgRepository) RestoreStock(ctx context.Context, tenantID, productID string, variantID *string, qty int, refID string) error {
	_, err := r.db.Exec(ctx,
		`INSERT INTO stock_transactions (tenant_id, product_id, variant_id, type, quantity, reference_id, performed_by)
		 VALUES ($1, $2, $3, 'refund', $4, $5, 'system')`,
		tenantID, productID, variantID, qty, refID)
	return err
}

// ─── Unused time import fix ───────────────────────────────────────────────────
var _ = time.Now
