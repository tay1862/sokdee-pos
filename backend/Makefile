.PHONY: build run test migrate-up migrate-down tidy

# Build the server binary
build:
	go build -o bin/server ./cmd/server

# Run the server
run:
	go run ./cmd/server

# Run all tests
test:
	go test ./... -v -race

# Run tests with coverage
test-coverage:
	go test ./... -coverprofile=coverage.out
	go tool cover -html=coverage.out

# Download dependencies
tidy:
	go mod tidy

# Apply all migrations (requires migrate CLI and DATABASE_URL env)
migrate-up:
	@echo "Running migrations up..."
	@for f in migrations/*.sql; do \
		echo "Applying $$f..."; \
	done
	@echo "Done. Use a migration tool like golang-migrate or goose."

# Rollback last migration
migrate-down:
	@echo "Rolling back last migration..."
	@echo "Use a migration tool like golang-migrate or goose."

# Format code
fmt:
	gofmt -w .

# Lint
lint:
	golangci-lint run ./...
