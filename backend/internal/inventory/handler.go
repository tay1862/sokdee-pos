package inventory

import (
	"encoding/csv"
	"encoding/json"
	"fmt"
	"net/http"
	"strings"

	"github.com/sokdee/pos-backend/internal/auth"
	apperrors "github.com/sokdee/pos-backend/pkg/errors"
)

// Handler handles inventory HTTP endpoints
type Handler struct {
	repo    Repository
	maxProd func(tenantID string) (*int, error)
}

// NewHandler creates a new inventory handler
func NewHandler(repo Repository, maxProducts func(tenantID string) (*int, error)) *Handler {
	return &Handler{repo: repo, maxProd: maxProducts}
}

// ─── Categories ───────────────────────────────────────────────────────────────

func (h *Handler) ListCategories(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	cats, err := h.repo.ListCategories(r.Context(), claims.TenantID)
	if err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to list categories")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, map[string]any{"categories": cats})
}

func (h *Handler) CreateCategory(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	var cat Category
	if err := json.NewDecoder(r.Body).Decode(&cat); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}
	cat.TenantID = claims.TenantID
	if cat.Name == "" {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "name is required")
		return
	}
	if err := h.repo.CreateCategory(r.Context(), &cat); err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to create category")
		return
	}
	apperrors.RespondJSON(w, http.StatusCreated, cat)
}

// ─── Products ─────────────────────────────────────────────────────────────────

func (h *Handler) ListProducts(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	products, err := h.repo.ListProducts(r.Context(), claims.TenantID, true)
	if err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to list products")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, map[string]any{"products": products})
}

func (h *Handler) GetProduct(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	id := extractLastSegment(r.URL.Path)
	p, err := h.repo.GetProduct(r.Context(), claims.TenantID, id)
	if err != nil || p == nil {
		apperrors.RespondError(w, http.StatusNotFound, apperrors.ErrNotFound, "product not found")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, p)
}

func (h *Handler) CreateProduct(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())

	// Check plan product limit
	if h.maxProd != nil {
		maxPtr, _ := h.maxProd(claims.TenantID)
		if maxPtr != nil {
			count, _ := h.repo.CountProducts(r.Context(), claims.TenantID)
			if count >= *maxPtr {
				apperrors.RespondError(w, http.StatusConflict, apperrors.ErrPlanLimitExceeded,
					"product limit reached for your plan",
					map[string]any{"current": count, "max": *maxPtr})
				return
			}
		}
	}

	var p Product
	if err := json.NewDecoder(r.Body).Decode(&p); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}
	p.TenantID = claims.TenantID
	if p.Name == "" || p.SellPrice <= 0 {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "name and sell_price are required")
		return
	}
	if err := h.repo.CreateProduct(r.Context(), &p); err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to create product")
		return
	}
	apperrors.RespondJSON(w, http.StatusCreated, p)
}

func (h *Handler) UpdateProduct(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	id := extractLastSegment(r.URL.Path)

	existing, err := h.repo.GetProduct(r.Context(), claims.TenantID, id)
	if err != nil || existing == nil {
		apperrors.RespondError(w, http.StatusNotFound, apperrors.ErrNotFound, "product not found")
		return
	}
	if err := json.NewDecoder(r.Body).Decode(existing); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}
	existing.ID = id
	existing.TenantID = claims.TenantID
	if err := h.repo.UpdateProduct(r.Context(), existing); err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to update product")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, existing)
}

func (h *Handler) DeleteProduct(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	id := extractLastSegment(r.URL.Path)
	if err := h.repo.DeleteProduct(r.Context(), claims.TenantID, id); err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to delete product")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, map[string]string{"message": "product deleted"})
}

// ImportCSV handles POST /api/v1/products/import
func (h *Handler) ImportCSV(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())

	if err := r.ParseMultipartForm(10 << 20); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "failed to parse form")
		return
	}
	file, _, err := r.FormFile("file")
	if err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "file is required")
		return
	}
	defer file.Close()

	reader := csv.NewReader(file)
	records, err := reader.ReadAll()
	if err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid CSV format")
		return
	}

	if len(records) < 2 {
		apperrors.RespondJSON(w, http.StatusOK, map[string]any{"imported": 0})
		return
	}

	// Expected CSV columns: name, sell_price, cost_price, barcode, unit
	var products []*Product
	for _, row := range records[1:] { // skip header
		if len(row) < 2 {
			continue
		}
		var sellPrice float64
		if _, err := parseFloat(row[1], &sellPrice); err != nil {
			continue
		}
		p := &Product{
			TenantID:  claims.TenantID,
			Name:      strings.TrimSpace(row[0]),
			SellPrice: sellPrice,
			IsActive:  true,
		}
		if len(row) > 2 && row[2] != "" {
			var cp float64
			if _, err := parseFloat(row[2], &cp); err == nil {
				p.CostPrice = &cp
			}
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

	if err := h.repo.BulkCreateProducts(r.Context(), products); err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to import products")
		return
	}

	apperrors.RespondJSON(w, http.StatusOK, map[string]any{"imported": len(products)})
}

// ─── Stock ────────────────────────────────────────────────────────────────────

func (h *Handler) StockIn(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	var req struct {
		ProductID string   `json:"product_id"`
		VariantID *string  `json:"variant_id"`
		Quantity  int      `json:"quantity"`
		CostPrice *float64 `json:"cost_price"`
		Reason    *string  `json:"reason"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}
	if req.Quantity <= 0 {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "quantity must be positive")
		return
	}
	tx := &StockTransaction{
		TenantID:    claims.TenantID,
		ProductID:   req.ProductID,
		VariantID:   req.VariantID,
		Type:        "stock_in",
		Quantity:    req.Quantity,
		CostPrice:   req.CostPrice,
		Reason:      req.Reason,
		PerformedBy: claims.Subject,
	}
	if err := h.repo.CreateStockTransaction(r.Context(), tx); err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to record stock in")
		return
	}
	apperrors.RespondJSON(w, http.StatusCreated, tx)
}

func (h *Handler) StockAdjust(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	var req struct {
		ProductID string  `json:"product_id"`
		VariantID *string `json:"variant_id"`
		Quantity  int     `json:"quantity"` // can be negative
		Reason    string  `json:"reason"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}
	if req.Reason == "" {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "reason is required for stock adjustment")
		return
	}
	tx := &StockTransaction{
		TenantID:    claims.TenantID,
		ProductID:   req.ProductID,
		VariantID:   req.VariantID,
		Type:        "adjustment",
		Quantity:    req.Quantity,
		Reason:      &req.Reason,
		PerformedBy: claims.Subject,
	}
	if err := h.repo.CreateStockTransaction(r.Context(), tx); err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to record adjustment")
		return
	}
	apperrors.RespondJSON(w, http.StatusCreated, tx)
}

func (h *Handler) ListStockTransactions(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	productID := r.URL.Query().Get("product_id")
	txs, err := h.repo.ListStockTransactions(r.Context(), claims.TenantID, productID)
	if err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to list transactions")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, map[string]any{"transactions": txs})
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

func extractLastSegment(path string) string {
	parts := strings.Split(strings.TrimSuffix(path, "/"), "/")
	return parts[len(parts)-1]
}

func parseFloat(s string, out *float64) (float64, error) {
	var v float64
	_, err := fmt.Sscanf(strings.TrimSpace(s), "%f", &v)
	if err != nil {
		return 0, err
	}
	*out = v
	return v, nil
}
