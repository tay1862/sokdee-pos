package pos

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
)

// PgRepository implements Repository (orders + payments + void + refund)
type PgRepository struct{ db *pgxpool.Pool }

func NewPgRepository(db *pgxpool.Pool) *PgRepository { return &PgRepository{db: db} }

func (r *PgRepository) CreateOrder(ctx context.Context, order *Order) error {
	orderNum := fmt.Sprintf("ORD-%d", time.Now().UnixMilli()%1000000)
	return r.db.QueryRow(ctx,
		`INSERT INTO orders (tenant_id, order_number, table_id, cashier_id, shift_id,
		        status, subtotal, discount_amount, tax_amount, total, notes, idempotency_key)
		 VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
		 RETURNING id, order_number, created_at`,
		order.TenantID, orderNum, order.TableID, order.CashierID, order.ShiftID,
		"open", order.Subtotal, order.DiscountAmount, order.TaxAmount, order.Total,
		order.Notes, order.IdempotencyKey,
	).Scan(&order.ID, &order.OrderNumber, &order.CreatedAt)
}

func (r *PgRepository) GetOrder(ctx context.Context, tenantID, id string) (*Order, error) {
	var o Order
	err := r.db.QueryRow(ctx,
		`SELECT id, tenant_id, order_number, table_id, cashier_id, shift_id,
		        status, subtotal, discount_amount, tax_amount, total, notes, created_at, paid_at
		 FROM orders WHERE id=$1 AND tenant_id=$2`, id, tenantID,
	).Scan(&o.ID, &o.TenantID, &o.OrderNumber, &o.TableID, &o.CashierID, &o.ShiftID,
		&o.Status, &o.Subtotal, &o.DiscountAmount, &o.TaxAmount, &o.Total,
		&o.Notes, &o.CreatedAt, &o.PaidAt)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}

	// Load items
	rows, err := r.db.Query(ctx,
		`SELECT id, order_id, tenant_id, product_id, variant_id, product_name,
		        unit_price, quantity, discount, line_total, modifiers, notes, kds_status
		 FROM order_items WHERE order_id=$1`, o.ID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	for rows.Next() {
		var item OrderItem
		var modsJSON []byte
		if err := rows.Scan(&item.ID, &item.OrderID, &item.TenantID, &item.ProductID,
			&item.VariantID, &item.ProductName, &item.UnitPrice, &item.Quantity,
			&item.Discount, &item.LineTotal, &modsJSON, &item.Notes, &item.KDSStatus); err != nil {
			return nil, err
		}
		_ = json.Unmarshal(modsJSON, &item.Modifiers)
		o.Items = append(o.Items, item)
	}
	return &o, nil
}

func (r *PgRepository) ListOrders(ctx context.Context, tenantID, status string) ([]*Order, error) {
	q := `SELECT id, tenant_id, order_number, table_id, cashier_id, shift_id,
		         status, subtotal, discount_amount, tax_amount, total, created_at, paid_at
		  FROM orders WHERE tenant_id=$1`
	args := []any{tenantID}
	if status != "" {
		q += " AND status=$2"
		args = append(args, status)
	}
	q += " ORDER BY created_at DESC LIMIT 50"

	rows, err := r.db.Query(ctx, q, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var orders []*Order
	for rows.Next() {
		var o Order
		if err := rows.Scan(&o.ID, &o.TenantID, &o.OrderNumber, &o.TableID, &o.CashierID,
			&o.ShiftID, &o.Status, &o.Subtotal, &o.DiscountAmount, &o.TaxAmount,
			&o.Total, &o.CreatedAt, &o.PaidAt); err != nil {
			return nil, err
		}
		orders = append(orders, &o)
	}
	return orders, nil
}

func (r *PgRepository) UpdateOrderStatus(ctx context.Context, tenantID, id, status string) error {
	_, err := r.db.Exec(ctx,
		`UPDATE orders SET status=$1, updated_at=NOW() WHERE id=$2 AND tenant_id=$3`,
		status, id, tenantID)
	return err
}

func (r *PgRepository) AddOrderItems(ctx context.Context, items []OrderItem) error {
	for _, item := range items {
		modsJSON, _ := json.Marshal(item.Modifiers)
		_, err := r.db.Exec(ctx,
			`INSERT INTO order_items (order_id, tenant_id, product_id, variant_id, product_name,
			        unit_price, quantity, discount, line_total, modifiers, notes)
			 VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)`,
			item.OrderID, item.TenantID, item.ProductID, item.VariantID, item.ProductName,
			item.UnitPrice, item.Quantity, item.Discount, item.LineTotal, modsJSON, item.Notes)
		if err != nil {
			return err
		}
	}
	return nil
}

func (r *PgRepository) ProcessPayment(ctx context.Context, tenantID, orderID string, payments []PaymentLine) error {
	tx, err := r.db.Begin(ctx)
	if err != nil {
		return err
	}
	defer tx.Rollback(ctx)

	for _, p := range payments {
		amountLAK := p.Amount * p.ExchangeRate
		_, err := tx.Exec(ctx,
			`INSERT INTO payments (order_id, tenant_id, method, currency, amount, amount_lak, exchange_rate)
			 VALUES ($1, $2, $3, $4, $5, $6, $7)`,
			orderID, tenantID, p.Method, p.Currency, p.Amount, amountLAK, p.ExchangeRate)
		if err != nil {
			return err
		}
	}

	_, err = tx.Exec(ctx,
		`UPDATE orders SET status='paid', paid_at=NOW(), updated_at=NOW() WHERE id=$1 AND tenant_id=$2`,
		orderID, tenantID)
	if err != nil {
		return err
	}

	// Deduct stock for each item
	rows, err := tx.Query(ctx,
		`SELECT product_id, variant_id, quantity FROM order_items WHERE order_id=$1`, orderID)
	if err != nil {
		return err
	}
	defer rows.Close()
	for rows.Next() {
		var productID string
		var variantID *string
		var qty int
		if err := rows.Scan(&productID, &variantID, &qty); err != nil {
			return err
		}
		_, err = tx.Exec(ctx,
			`INSERT INTO stock_transactions (tenant_id, product_id, variant_id, type, quantity, reference_id, performed_by)
			 VALUES ($1, $2, $3, 'sale', $4, $5, 'system')`,
			tenantID, productID, variantID, -qty, orderID)
		if err != nil {
			return err
		}
	}

	return tx.Commit(ctx)
}

func (r *PgRepository) VoidOrder(ctx context.Context, tenantID, orderID, reason, userID, shiftID string) error {
	tx, err := r.db.Begin(ctx)
	if err != nil {
		return err
	}
	defer tx.Rollback(ctx)

	_, err = tx.Exec(ctx,
		`UPDATE orders SET status='voided', updated_at=NOW() WHERE id=$1 AND tenant_id=$2`,
		orderID, tenantID)
	if err != nil {
		return err
	}

	_, err = tx.Exec(ctx,
		`INSERT INTO void_logs (tenant_id, order_id, reason, voided_by, shift_id)
		 VALUES ($1, $2, $3, $4, $5)`,
		tenantID, orderID, reason, userID, shiftID)
	if err != nil {
		return err
	}

	return tx.Commit(ctx)
}

func (r *PgRepository) RefundOrder(ctx context.Context, tenantID, orderID string, req RefundRequest) error {
	tx, err := r.db.Begin(ctx)
	if err != nil {
		return err
	}
	defer tx.Rollback(ctx)

	// Get order total
	var total float64
	var currency string
	_ = tx.QueryRow(ctx,
		`SELECT total, 'LAK' FROM orders WHERE id=$1`, orderID,
	).Scan(&total, &currency)

	_, err = tx.Exec(ctx,
		`INSERT INTO refunds (tenant_id, original_order_id, reason, approved_by, total_refund, currency)
		 VALUES ($1, $2, $3, $4, $5, $6)`,
		tenantID, orderID, req.Reason, req.ApprovedBy, total, "LAK")
	if err != nil {
		return err
	}

	_, err = tx.Exec(ctx,
		`UPDATE orders SET status='refunded', updated_at=NOW() WHERE id=$1 AND tenant_id=$2`,
		orderID, tenantID)
	if err != nil {
		return err
	}

	// Restore stock
	rows, err := tx.Query(ctx,
		`SELECT product_id, variant_id, quantity FROM order_items WHERE order_id=$1`, orderID)
	if err != nil {
		return err
	}
	defer rows.Close()
	for rows.Next() {
		var productID string
		var variantID *string
		var qty int
		if err := rows.Scan(&productID, &variantID, &qty); err != nil {
			return err
		}
		_, err = tx.Exec(ctx,
			`INSERT INTO stock_transactions (tenant_id, product_id, variant_id, type, quantity, reference_id, performed_by)
			 VALUES ($1, $2, $3, 'refund', $4, $5, $6)`,
			tenantID, productID, variantID, qty, orderID, req.ApprovedBy)
		if err != nil {
			return err
		}
	}

	return tx.Commit(ctx)
}

func (r *PgRepository) GetActiveShiftID(ctx context.Context, tenantID, cashierID string) (*string, error) {
	var id string
	err := r.db.QueryRow(ctx,
		`SELECT id FROM shifts WHERE tenant_id=$1 AND cashier_id=$2 AND status='open' LIMIT 1`,
		tenantID, cashierID,
	).Scan(&id)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, nil
	}
	return &id, err
}

func (r *PgRepository) GetExchangeRate(ctx context.Context, tenantID, currency string) (float64, error) {
	var rate float64
	err := r.db.QueryRow(ctx,
		`SELECT rate FROM exchange_rates WHERE tenant_id=$1 AND currency=$2`,
		tenantID, currency,
	).Scan(&rate)
	if errors.Is(err, pgx.ErrNoRows) {
		return 0, nil
	}
	return rate, err
}

// ─── Shift Repository ─────────────────────────────────────────────────────────

// PgShiftRepository implements ShiftRepository
type PgShiftRepository struct{ db *pgxpool.Pool }

func NewPgShiftRepository(db *pgxpool.Pool) *PgShiftRepository { return &PgShiftRepository{db: db} }

func (r *PgShiftRepository) GetActiveShift(ctx context.Context, tenantID, cashierID string) (*Shift, error) {
	var s Shift
	err := r.db.QueryRow(ctx,
		`SELECT id, tenant_id, cashier_id, device_id, opening_balance, status, opened_at
		 FROM shifts WHERE tenant_id=$1 AND cashier_id=$2 AND status='open' LIMIT 1`,
		tenantID, cashierID,
	).Scan(&s.ID, &s.TenantID, &s.CashierID, &s.DeviceID, &s.OpeningBalance, &s.Status, &s.OpenedAt)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, nil
	}
	return &s, err
}

func (r *PgShiftRepository) CreateShift(ctx context.Context, shift *Shift) error {
	return r.db.QueryRow(ctx,
		`INSERT INTO shifts (tenant_id, cashier_id, device_id, opening_balance, status)
		 VALUES ($1, $2, $3, $4, 'open') RETURNING id, opened_at`,
		shift.TenantID, shift.CashierID, shift.DeviceID, shift.OpeningBalance,
	).Scan(&shift.ID, &shift.OpenedAt)
}

func (r *PgShiftRepository) CloseShift(ctx context.Context, tenantID, shiftID string, closingBalance float64) error {
	_, err := r.db.Exec(ctx,
		`UPDATE shifts SET status='closed', closing_balance=$1, closed_at=NOW(), updated_at=NOW()
		 WHERE id=$2 AND tenant_id=$3`,
		closingBalance, shiftID, tenantID)
	return err
}

func (r *PgShiftRepository) ListShifts(ctx context.Context, tenantID string) ([]*Shift, error) {
	rows, err := r.db.Query(ctx,
		`SELECT id, tenant_id, cashier_id, device_id, opening_balance, closing_balance, status, opened_at, closed_at
		 FROM shifts WHERE tenant_id=$1 ORDER BY opened_at DESC LIMIT 50`, tenantID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var shifts []*Shift
	for rows.Next() {
		var s Shift
		if err := rows.Scan(&s.ID, &s.TenantID, &s.CashierID, &s.DeviceID,
			&s.OpeningBalance, &s.ClosingBalance, &s.Status, &s.OpenedAt, &s.ClosedAt); err != nil {
			return nil, err
		}
		shifts = append(shifts, &s)
	}
	return shifts, nil
}

func (r *PgShiftRepository) GetShiftSummary(ctx context.Context, tenantID, shiftID string) (*ShiftSummary, error) {
	var s ShiftSummary
	s.ShiftID = shiftID

	// Aggregate from orders and payments
	err := r.db.QueryRow(ctx, `
		SELECT
		  COALESCE(SUM(o.total), 0),
		  COALESCE(SUM(CASE WHEN p.method='cash' THEN p.amount_lak ELSE 0 END), 0),
		  COALESCE(SUM(CASE WHEN p.method='qr' THEN p.amount_lak ELSE 0 END), 0),
		  COALESCE(SUM(CASE WHEN p.method='transfer' THEN p.amount_lak ELSE 0 END), 0),
		  COUNT(DISTINCT o.id),
		  (SELECT COUNT(*) FROM void_logs vl WHERE vl.shift_id=$2),
		  (SELECT COUNT(*) FROM refunds rf
		   JOIN orders ro ON rf.original_order_id=ro.id
		   WHERE ro.shift_id=$2)
		FROM orders o
		LEFT JOIN payments p ON p.order_id=o.id
		WHERE o.tenant_id=$1 AND o.shift_id=$2 AND o.status='paid'`,
		tenantID, shiftID,
	).Scan(&s.TotalSales, &s.TotalCash, &s.TotalQR, &s.TotalTransfer,
		&s.TransactionCount, &s.VoidCount, &s.RefundCount)
	if err != nil {
		return nil, err
	}

	// Get opening balance
	var openingBalance float64
	var closingBalance *float64
	_ = r.db.QueryRow(ctx,
		`SELECT opening_balance, closing_balance FROM shifts WHERE id=$1`, shiftID,
	).Scan(&openingBalance, &closingBalance)

	s.ExpectedCash = openingBalance + s.TotalCash
	if closingBalance != nil {
		s.ActualCash = *closingBalance
	}
	s.CashDifference = s.ActualCash - s.ExpectedCash

	return &s, nil
}

// ─── Exchange Rate Repository ─────────────────────────────────────────────────

// PgExchangeRateRepository implements ExchangeRateRepository
type PgExchangeRateRepository struct{ db *pgxpool.Pool }

func NewPgExchangeRateRepository(db *pgxpool.Pool) *PgExchangeRateRepository {
	return &PgExchangeRateRepository{db: db}
}

func (r *PgExchangeRateRepository) GetExchangeRates(ctx context.Context, tenantID string) ([]*ExchangeRate, error) {
	rows, err := r.db.Query(ctx,
		`SELECT id, tenant_id, currency, rate, set_by, effective_at
		 FROM exchange_rates WHERE tenant_id=$1`, tenantID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var rates []*ExchangeRate
	for rows.Next() {
		var er ExchangeRate
		if err := rows.Scan(&er.ID, &er.TenantID, &er.Currency, &er.Rate, &er.SetBy, &er.EffectiveAt); err != nil {
			return nil, err
		}
		rates = append(rates, &er)
	}
	return rates, nil
}

func (r *PgExchangeRateRepository) SetExchangeRate(ctx context.Context, rate *ExchangeRate) error {
	return r.db.QueryRow(ctx,
		`INSERT INTO exchange_rates (tenant_id, currency, rate, set_by, effective_at)
		 VALUES ($1, $2, $3, $4, NOW())
		 ON CONFLICT (tenant_id, currency) DO UPDATE
		   SET rate=$3, set_by=$4, effective_at=NOW()
		 RETURNING id, effective_at`,
		rate.TenantID, rate.Currency, rate.Rate, rate.SetBy,
	).Scan(&rate.ID, &rate.EffectiveAt)
}
