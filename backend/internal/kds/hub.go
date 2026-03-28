package kds

import (
	"encoding/json"
	"log"
	"sync"
)

// MessageType defines KDS WebSocket message types
type MessageType string

const (
	MsgNewOrder   MessageType = "new_order"
	MsgAddItems   MessageType = "add_items"
	MsgItemReady  MessageType = "item_ready"
	MsgOrderReady MessageType = "order_ready"
)

// Message is a KDS WebSocket message
type Message struct {
	Type    MessageType    `json:"type"`
	Payload map[string]any `json:"payload"`
}

// Client represents a connected WebSocket client
type Client struct {
	TenantID string
	Send     chan []byte
}

// Hub manages WebSocket connections grouped by tenant
type Hub struct {
	mu      sync.RWMutex
	tenants map[string]map[*Client]bool // tenantID → set of clients
}

// NewHub creates a new KDS hub
func NewHub() *Hub {
	return &Hub{
		tenants: make(map[string]map[*Client]bool),
	}
}

// Register adds a client to its tenant room
func (h *Hub) Register(client *Client) {
	h.mu.Lock()
	defer h.mu.Unlock()

	if h.tenants[client.TenantID] == nil {
		h.tenants[client.TenantID] = make(map[*Client]bool)
	}
	h.tenants[client.TenantID][client] = true
	log.Printf("KDS: client registered for tenant %s (total: %d)", client.TenantID, len(h.tenants[client.TenantID]))
}

// Unregister removes a client from its tenant room
func (h *Hub) Unregister(client *Client) {
	h.mu.Lock()
	defer h.mu.Unlock()

	if clients, ok := h.tenants[client.TenantID]; ok {
		delete(clients, client)
		close(client.Send)
		if len(clients) == 0 {
			delete(h.tenants, client.TenantID)
		}
	}
}

// Broadcast sends a message to all clients in a tenant room
func (h *Hub) Broadcast(tenantID string, msg Message) {
	data, err := json.Marshal(msg)
	if err != nil {
		log.Printf("KDS: failed to marshal message: %v", err)
		return
	}

	h.mu.RLock()
	clients := h.tenants[tenantID]
	h.mu.RUnlock()

	for client := range clients {
		select {
		case client.Send <- data:
		default:
			// Client buffer full — unregister
			h.Unregister(client)
		}
	}
}

// BroadcastNewOrder notifies kitchen of a new order
func (h *Hub) BroadcastNewOrder(tenantID, orderID, tableNumber string, items []map[string]any) {
	h.Broadcast(tenantID, Message{
		Type: MsgNewOrder,
		Payload: map[string]any{
			"order_id":     orderID,
			"table":        tableNumber,
			"items":        items,
			"received_at":  nowISO(),
		},
	})
}

// BroadcastAddItems notifies kitchen of additional items added to an existing order
func (h *Hub) BroadcastAddItems(tenantID, orderID string, items []map[string]any) {
	h.Broadcast(tenantID, Message{
		Type: MsgAddItems,
		Payload: map[string]any{
			"order_id": orderID,
			"items":    items,
		},
	})
}

// BroadcastItemReady notifies POS that a specific item is ready
func (h *Hub) BroadcastItemReady(tenantID, orderID, itemID string) {
	h.Broadcast(tenantID, Message{
		Type: MsgItemReady,
		Payload: map[string]any{
			"order_id": orderID,
			"item_id":  itemID,
		},
	})
}

// BroadcastOrderReady notifies POS that all items in an order are ready
func (h *Hub) BroadcastOrderReady(tenantID, orderID, tableNumber string) {
	h.Broadcast(tenantID, Message{
		Type: MsgOrderReady,
		Payload: map[string]any{
			"order_id": orderID,
			"table":    tableNumber,
		},
	})
}
