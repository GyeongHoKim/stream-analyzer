# Technology Stack

## Architecture

This is a **Wails v2** application - a desktop application framework that combines Go backend with React frontend.

## Backend

- **Language**: Go 1.23
- **Framework**: Wails v2.11.0
- **Pattern**: Go methods in `app.go` are automatically bound to frontend via Wails
- **Entry point**: `main.go` configures Wails runtime
- **Build**: Frontend assets are embedded in Go binary via `//go:embed all:frontend/dist`

## Frontend

- **Framework**: React 19
- **Language**: TypeScript 5.9
- **Build Tool**: Vite 7.2
- **Styling**: Tailwind CSS 4.1
- **UI Components**: shadcn/ui (New York variant)
- **Icons**: Lucide React
- **State Management**: React hooks
- **Utilities**:
  - `class-variance-authority` for component variants
  - `clsx` and `tailwind-merge` for class merging (via `cn()` utility)

## Development Tools

### Linting & Formatting
- **Frontend**: Biome 2.3.11 (strict rules)
- **Backend**: gofmt + go vet

### Testing
- **Frontend**: Vitest 4.0
- **Backend**: go test with race detector

### Build System
- **Makefile** with targets: install, dev, build, lint, test, clean, help

## Key Dependencies

### Frontend
- `@tailwindcss/vite`: Tailwind CSS 4 integration
- `lucide-react`: Icon library
- `@biomejs/biome`: Linter and formatter
- `vitest`: Testing framework
- `@vitejs/plugin-react`: React plugin with React Compiler support

### Backend
- `github.com/wailsapp/wails/v2`: Core framework
- Various indirect dependencies for WebView, WebSocket, etc.

## Platform

- **Development OS**: macOS (Darwin)
- **Build Output**: Native desktop binary at `build/bin/app`
- **Hot Reload**: Supported via `wails dev` command
