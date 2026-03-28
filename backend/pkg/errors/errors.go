package errors

import (
	"encoding/json"
	"net/http"
)

// AppError represents a structured API error response
type AppError struct {
	Code    string         `json:"code"`
	Message string         `json:"message"`
	Details map[string]any `json:"details,omitempty"`
}

// ErrorResponse wraps AppError for JSON response
type ErrorResponse struct {
	Error AppError `json:"error"`
}

// Common error codes
const (
	ErrUnauthorized       = "unauthorized"
	ErrForbidden          = "forbidden"
	ErrNotFound           = "not_found"
	ErrValidation         = "validation_error"
	ErrPlanLimitExceeded  = "plan_limit_exceeded"
	ErrTenantSuspended    = "tenant_suspended"
	ErrTenantExpired      = "tenant_expired"
	ErrCurrencyNotSet     = "currency_not_configured"
	ErrStockInsufficient  = "stock_insufficient"
	ErrShiftAlreadyOpen   = "shift_already_open"
	ErrInvalidPIN         = "invalid_pin"
	ErrAccountLocked      = "account_locked"
	ErrDeviceNotRegistered = "device_not_registered"
	ErrTokenRevoked        = "token_revoked"
	ErrInternal            = "internal_error"
)

// RespondError writes a JSON error response
func RespondError(w http.ResponseWriter, status int, code, message string, details ...map[string]any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)

	resp := ErrorResponse{
		Error: AppError{
			Code:    code,
			Message: message,
		},
	}
	if len(details) > 0 {
		resp.Error.Details = details[0]
	}

	_ = json.NewEncoder(w).Encode(resp)
}

// RespondJSON writes a JSON success response
func RespondJSON(w http.ResponseWriter, status int, data any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(data)
}
