.PHONY: install dev build lint test clean help

# Variables
FRONTEND_DIR := frontend
BINARY_NAME := app
BUILD_DIR := build/bin

# Default target
.DEFAULT_GOAL := help

## install: Install all dependencies (Go modules + Frontend packages)
install:
	@echo "Installing Go dependencies..."
	go mod download
	@echo "Installing frontend dependencies..."
	cd $(FRONTEND_DIR) && npm install

## dev: Run development server with hot reload
dev:
	@echo "Starting Wails dev server..."
	wails dev

## build: Build production binary
build:
	@echo "Building production binary..."
	wails build
	@echo "Binary built at: $(BUILD_DIR)/$(BINARY_NAME)"

## lint: Run linters for both Go and TypeScript
lint: lint-go lint-frontend

lint-go:
	@echo "Running Go formatter check..."
	@gofmt -l . | grep . && echo "Please run: gofmt -w ." && exit 1 || echo "✓ Code is formatted"
	@echo "Running go vet..."
	go vet ./...

lint-frontend:
	@echo "Running frontend linter..."
	cd $(FRONTEND_DIR) && npm run lint

## test: Run all tests
test: test-go test-frontend

test-go:
	@echo "Running Go tests..."
	go test -v -race -coverprofile=coverage.out ./...

test-frontend:
	@echo "Running frontend tests..."
	cd $(FRONTEND_DIR) && npm test

## clean: Clean build artifacts and dependencies
clean:
	@echo "Cleaning build artifacts..."
	rm -rf $(BUILD_DIR)
	rm -rf $(FRONTEND_DIR)/dist
	rm -rf $(FRONTEND_DIR)/node_modules
	rm -f coverage.out

## help: Show this help message
help:
	@echo "Available targets:"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'