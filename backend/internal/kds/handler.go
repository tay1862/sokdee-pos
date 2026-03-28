package kds

import (
"encoding/json"
"log"
"net/http"
"time"

"github.com/gorilla/websocket"
"github.com/sokdee/pos-backend/internal/auth"
apperrors "github.com/sokdee/pos-backend/pkg/errors"
)

const (
writeWait      = 10 * time.Second
pongWait       = 60 * time.Second
pingPeriod     = (pongWait * 9) / 10
maxMessageSize = 4096
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
	CheckOrigin:     func(r *http.Request) bool { return true },
}

// Handler handles KDS WebSocket connections
type Handler struct{ hub *Hub }

// NewHandler creates a new KDS handler
func NewHandler(hub *Hub) *Handler { return &Handler{hub: hub} }

// ServeWS handles ws://backend/ws/kds?token=JWT
func (h *Handler) ServeWS(w http.ResponseWriter, r *http.Request) {
	tokenStr := r.URL.Query().Get("token")
	if tokenStr == "" {
		apperrors.RespondError(w, http.StatusUnauthorized, apperrors.ErrUnauthorized, "token required")
		return
	}
	claims, err := auth.ParseAccessToken(tokenStr)
	if err != nil {
		apperrors.RespondError(w, http.StatusUnauthorized, apperrors.ErrUnauthorized, "invalid token")
		return
	}
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Printf("KDS: upgrade error: %v", err)
		return
	}
	client := &Client{TenantID: claims.TenantID, Send: make(chan []byte, 256)}
	h.hub.Register(client)
	go h.writePump(conn, client)
	go h.readPump(conn, client)
}

func (h *Handler) readPump(conn *websocket.Conn, client *Client) {
	defer func() { h.hub.Unregister(client); conn.Close() }()
	conn.SetReadLimit(maxMessageSize)
	_ = conn.SetReadDeadline(time.Now().Add(pongWait))
	conn.SetPongHandler(func(string) error {
return conn.SetReadDeadline(time.Now().Add(pongWait))
	})
	for {
		_, msgBytes, err := conn.ReadMessage()
		if err != nil {
			if websocket.IsUnexpectedCloseError(err, websocket.CloseGoingAway, websocket.CloseAbnormalClosure) {
				log.Printf("KDS: read error: %v", err)
			}
			break
		}
		var msg Message
		if jsonErr := json.Unmarshal(msgBytes, &msg); jsonErr != nil {
			continue
		}
		switch msg.Type {
		case MsgItemReady:
			orderID, _ := msg.Payload["order_id"].(string)
			itemID, _ := msg.Payload["item_id"].(string)
			h.hub.BroadcastItemReady(client.TenantID, orderID, itemID)
		case MsgOrderReady:
			orderID, _ := msg.Payload["order_id"].(string)
			table, _ := msg.Payload["table"].(string)
			h.hub.BroadcastOrderReady(client.TenantID, orderID, table)
		}
	}
}

func (h *Handler) writePump(conn *websocket.Conn, client *Client) {
	ticker := time.NewTicker(pingPeriod)
	defer func() { ticker.Stop(); conn.Close() }()
	for {
		select {
		case msg, ok := <-client.Send:
			_ = conn.SetWriteDeadline(time.Now().Add(writeWait))
			if !ok {
				_ = conn.WriteMessage(websocket.CloseMessage, []byte{})
				return
			}
			if err := conn.WriteMessage(websocket.TextMessage, msg); err != nil {
				return
			}
		case <-ticker.C:
			_ = conn.SetWriteDeadline(time.Now().Add(writeWait))
			if err := conn.WriteMessage(websocket.PingMessage, nil); err != nil {
				return
			}
		}
	}
}
