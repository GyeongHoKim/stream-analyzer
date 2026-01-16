# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Stream Analyzer is a desktop application built with Wails (Go + React) for analyzing H.264/H.265 video streams. It provides NAL unit inspection, hex viewing, and frame visualization capabilities for video codec debugging.

**Tech Stack:**
- **Backend**: Go 1.23 with Wails v2 framework
- **Frontend**: React 19 + TypeScript + Vite + Tailwind CSS 4
- **Linter**: Biome (frontend), gofmt + go vet (backend)
- **Testing**: Vitest (frontend), go test (backend)

## Development Commands

```bash
# Install dependencies (Go modules + npm packages)
make install

# Run development server with hot reload
make dev

# Build production binary
make build

# Run ALL quality checks (format + lint)
make lint

# Run tests
make test

# Clean build artifacts
make clean
```

### Quality Gate Requirements

**CRITICAL**: Before committing any code changes, you MUST run and pass:
```bash
make lint
```

This runs:
- **Go**: `gofmt` formatter check + `go vet` static analysis
- **Frontend**: Biome linter with strict rules

All code must pass these checks before being considered complete.

### Running Individual Checks

```bash
# Go only
gofmt -l .               # Check formatting
gofmt -w .               # Fix formatting
go vet ./...             # Run static analysis
go test -v -race ./...   # Run Go tests with race detector

# Frontend only
cd frontend
npm run lint             # Run Biome linter (auto-fixes)
npm run format           # Run Biome formatter
npm test                 # Run Vitest tests
```

## Architecture

### Wails Integration Pattern

This is a Wails application where the Go backend and React frontend communicate via Wails bindings:

1. **Backend (Go)**:
   - `main.go`: Application entry point, configures Wails runtime
   - `app.go`: App struct with methods that are automatically bound to frontend
   - Methods on `App` struct are exposed to frontend via Wails bindings
   - `startup()` receives the Wails context for runtime operations

2. **Frontend (React)**:
   - Standard Vite + React setup with TypeScript
   - Calls Go backend methods through auto-generated Wails bindings
   - Built assets are embedded in Go binary via `//go:embed all:frontend/dist`

3. **Build Process**:
   - Frontend built first (`npm run build` → `frontend/dist`)
   - Go embeds frontend assets and compiles into single binary
   - Binary output: `build/bin/stream-analyzer`

### Frontend Code Style

The project uses **Biome** with strict linting rules:
- Tab indentation (not spaces)
- Double quotes for strings
- No `var` keyword (use `const`/`let`)
- No `any` type in TypeScript
- Unused variables are errors
- Comprehensive correctness and suspicious pattern detection

React-specific:
- Hooks must be at top level
- Exhaustive dependencies in useEffect (warning)

### UI Component Library

**Use shadcn/ui for all UI components.**

The project is configured with shadcn/ui:
- **Style**: New York variant
- **Icons**: Lucide React (from `lucide-react` package)
- **Path aliases** configured in `components.json`:
  - `@/components` → `src/components`
  - `@/components/ui` → `src/components/ui` (shadcn components)
  - `@/lib/utils` → `src/lib/utils`
  - `@/hooks` → `src/hooks`

**Adding shadcn components:**
```bash
cd frontend
npx shadcn@latest add [component-name]
```

The `cn()` utility function in `src/lib/utils.ts` is available for merging Tailwind classes.

## Project State

The project is in **early initialization**. The current codebase contains:
- Basic Wails boilerplate with a simple "Greet" example method
- Starter React app with Vite template
- Build system and quality tooling fully configured
- No actual video stream analysis functionality implemented yet

When implementing new features, follow the existing Wails pattern: add methods to `app.go` that can be called from the React frontend.
