package pos

import (
	"context"
	"encoding/json"
	"net/http"
	"time"

	"github.com/sokdee/pos-backend/internal/auth"
	apperrors "github.com/sokdee/pos-backend/pkg/errors"
)

// ExchangeRate holds a currency rate record
type ExchangeRate struct {
	ID          string    `json:"id"`
	TenantID    string    `json:"tenant_id"`
	Currency    string    `json:"currency"`
	Rate        float64   `json:"rate"`
	SetBy       string    `json:"set_by"`
	EffectiveAt time.Time `json:"effective_at"`
}

// ExchangeRateRepository defines data access for exchange rates
type ExchangeRateRepository interface {
	GetExchangeRates(ctx context.Context, tenantID string) ([]*ExchangeRate, error)
	SetExchangeRate(ctx context.Context, rate *ExchangeRate) error
}

// ExchangeRateHandler handles exchange rate endpoints
type ExchangeRateHandler struct {
	repo ExchangeRateRepository
}

// NewExchangeRateHandler creates a new exchange rate handler
func NewExchangeRateHandler(repo ExchangeRateRepository) *ExchangeRateHandler {
	return &ExchangeRateHandler{repo: repo}
}

// GetRates handles GET /api/v1/settings/exchange-rates
func (h *ExchangeRateHandler) GetRates(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	rates, err := h.repo.GetExchangeRates(r.Context(), claims.TenantID)
	if err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to get exchange rates")
		return
	}

	// Build a simple map: currency → rate
	rateMap := make(map[string]float64)
	for _, r := range rates {
		rateMap[r.Currency] = r.Rate
	}
	apperrors.RespondJSON(w, http.StatusOK, map[string]any{"rates": rateMap, "details": rates})
}

// SetRate handles POST /api/v1/settings/exchange-rates
func (h *ExchangeRateHandler) SetRate(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())

	var req struct {
		Currency string  `json:"currency"`
		Rate     float64 `json:"rate"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}

	if req.Currency == "" || req.Rate <= 0 {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "currency and rate > 0 are required")
		return
	}

	// Only THB and USD supported
	if req.Currency != "THB" && req.Currency != "USD" {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "only THB and USD are supported")
		return
	}

	rate := &ExchangeRate{
		TenantID:    claims.TenantID,
		Currency:    req.Currency,
		Rate:        req.Rate,
		SetBy:       claims.Subject,
		EffectiveAt: time.Now(),
	}

	if err := h.repo.SetExchangeRate(r.Context(), rate); err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to set exchange rate")
		return
	}

	apperrors.RespondJSON(w, http.StatusOK, rate)
}
