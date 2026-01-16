# Codebase Structure

## Project Root Layout

```
stream-analyzer/
├── frontend/              # React frontend application
├── build/                 # Build artifacts
│   └── bin/              # Compiled binary (app)
├── .specify/             # Project constitution and templates
│   ├── memory/           # Constitution and governance
│   └── templates/        # Spec, plan, task templates
├── main.go               # Wails application entry point
├── app.go                # App struct with Wails-bound methods
├── go.mod                # Go module definition
├── go.sum                # Go dependency checksums
├── Makefile              # Build and development commands
├── wails.json            # Wails configuration
├── CLAUDE.md             # Project development guidelines
├── README.md             # Project documentation
└── LICENSE               # MIT License
```

## Frontend Structure

```
frontend/
├── src/                  # Source code
│   ├── components/       # React components
│   │   └── ui/          # shadcn/ui components (DO NOT modify directly)
│   ├── lib/             # Utilities and helpers
│   │   └── utils.ts     # Contains cn() utility for class merging
│   ├── hooks/           # Custom React hooks
│   └── index.css        # Tailwind CSS entry point
├── public/              # Static assets
├── dist/                # Build output (embedded in Go binary)
├── node_modules/        # npm dependencies
├── package.json         # npm configuration and scripts
├── package-lock.json    # npm dependency lock
├── biome.json           # Biome linter/formatter config
├── components.json      # shadcn/ui configuration
├── tsconfig.json        # TypeScript configuration
├── tsconfig.app.json    # App-specific TypeScript config
├── tsconfig.node.json   # Node-specific TypeScript config
├── vite.config.ts       # Vite build configuration
└── index.html           # HTML entry point
```

## Backend Structure (Go)

The backend uses Wails convention:

- **`main.go`**: Application entry point
  - Configures Wails runtime
  - Embeds frontend assets via `//go:embed all:frontend/dist`
  - Starts the application

- **`app.go`**: Core application logic
  - Contains `App` struct
  - Methods on `App` are automatically exposed to frontend via Wails bindings
  - `startup(ctx context.Context)` receives Wails runtime context

Additional Go files would be organized as:
```
./
├── internal/            # Internal packages (if needed)
│   ├── parser/         # H.264/H.265 parsing logic
│   ├── decoder/        # Frame decoding logic
│   └── analyzer/       # Analysis utilities
└── pkg/                # Public packages (if needed)
```

## Configuration Files

### Frontend Configuration
- **`biome.json`**: Linter rules (strict mode, tabs, double quotes, no any, etc.)
- **`components.json`**: shadcn/ui configuration (New York style, Lucide icons)
- **`tsconfig.*.json`**: TypeScript compiler options
- **`vite.config.ts`**: Vite build and dev server configuration

### Backend Configuration
- **`go.mod`**: Go module dependencies (Wails v2.11.0)
- **`wails.json`**: Wails framework configuration

### Build Configuration
- **`Makefile`**: Unified build system for all operations

## Build Artifacts

```
build/
└── bin/
    └── app            # Final executable binary (macOS)
```

Frontend build output (`frontend/dist/`) is embedded in the Go binary during compilation.

## Key Directories to Note

### DO NOT MODIFY
- `frontend/src/components/ui/` - shadcn/ui components (extend via wrappers, don't modify)
- `frontend/node_modules/` - npm dependencies
- `build/` - Generated build artifacts

### MODIFY AS NEEDED
- `frontend/src/components/` - Custom React components
- `frontend/src/lib/` - Utility functions
- `frontend/src/hooks/` - Custom React hooks
- `app.go` - Backend methods exposed to frontend
- Additional Go packages for business logic

## Wails Integration Pattern

**Data Flow**:
1. User interacts with React UI (frontend)
2. React calls Go backend methods via Wails bindings
3. Go processes request (e.g., parse video stream)
4. Go returns data to frontend
5. React updates UI with results

**File Embedding**:
1. Frontend built to `frontend/dist/` via `npm run build`
2. Go embeds `frontend/dist/` via `//go:embed` directive
3. Wails serves embedded files in desktop WebView
4. Single binary output contains everything
