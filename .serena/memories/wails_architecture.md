# Wails Architecture Pattern

## What is Wails?

Wails is a framework for building desktop applications using Go and web frontend technologies (React, Vue, etc.). It embeds a WebView to display the frontend while running Go code as the backend.

**Think of it as**: Electron, but with Go instead of Node.js, and much smaller binaries.

## Application Flow

### Startup Sequence

1. **`main.go`** entry point:
   - Creates `App` instance
   - Configures Wails options (window size, title, etc.)
   - Embeds frontend assets from `frontend/dist/`
   - Binds `App` methods to frontend
   - Runs the application

2. **Wails runtime**:
   - Launches native WebView window
   - Loads embedded frontend HTML/CSS/JS
   - Exposes Go methods to JavaScript
   - Handles IPC (Inter-Process Communication)

3. **Frontend loads**:
   - React application initializes
   - Can call Go backend methods via auto-generated bindings

### Communication Pattern

**Frontend → Backend**:
```typescript
// In React component (frontend/src/)
import { MethodName } from '../wailsjs/go/main/App'

const result = await MethodName(param1, param2)
```

**Backend → Frontend**:
```go
// In app.go
func (a *App) MethodName(param1 string, param2 int) string {
    // Process request
    return "result"
}
```

Wails automatically:
- Generates TypeScript bindings from Go methods
- Handles serialization/deserialization
- Manages async/await for Go function calls

## File Organization

### Backend (Go)

**`main.go`**:
```go
//go:embed all:frontend/dist
var assets embed.FS

func main() {
    app := NewApp()
    
    err := wails.Run(&options.App{
        Title:  "Stream Analyzer",
        Width:  1024,
        Height: 768,
        AssetServer: &assetserver.Options{
            Assets: assets,
        },
        OnStartup: app.startup,
        Bind: []interface{}{
            app,
        },
    })
}
```

**`app.go`**:
```go
type App struct {
    ctx context.Context
}

func NewApp() *App {
    return &App{}
}

func (a *App) startup(ctx context.Context) {
    a.ctx = ctx
    // Initialization code
}

// This method is automatically exposed to frontend
func (a *App) AnalyzeStream(filePath string) (StreamData, error) {
    // Analysis logic
    return data, nil
}
```

### Frontend (React)

React code lives in `frontend/src/`. It's a standard Vite + React + TypeScript app with one key difference: access to Wails bindings.

**Generated bindings** (auto-created by Wails):
```
frontend/wailsjs/
├── go/
│   └── main/
│       └── App.js        # Auto-generated from app.go methods
└── runtime/
    └── runtime.js        # Wails runtime utilities
```

## Development vs Production

### Development Mode (`make dev`)

1. Vite dev server runs on localhost (hot reload enabled)
2. Wails creates WebView pointing to Vite dev server
3. Changes to frontend → instant hot reload
4. Changes to backend → Wails restarts

### Production Mode (`make build`)

1. `npm run build` compiles frontend to `frontend/dist/`
2. Go embeds `frontend/dist/` via `//go:embed`
3. Wails compiles everything to single binary
4. Binary contains both Go backend and frontend assets
5. No external dependencies needed to run

## Key Concepts

### Method Binding

Any public method on the `App` struct is automatically exposed to frontend:

```go
// ✅ Exposed to frontend (public method)
func (a *App) ParseVideo(path string) error { }

// ❌ NOT exposed (private method)
func (a *App) parseHeader(data []byte) Header { }

// ❌ NOT exposed (not on App struct)
func helperFunction() { }
```

### Context Usage

The `startup()` method receives Wails runtime context:

```go
func (a *App) startup(ctx context.Context) {
    a.ctx = ctx  // Store for later use
}

// Use context for runtime operations
func (a *App) ShowDialog() {
    runtime.MessageDialog(a.ctx, runtime.MessageDialogOptions{
        Title:   "Error",
        Message: "Something went wrong",
    })
}
```

### Data Types

Wails automatically converts between Go and JavaScript types:

| Go Type       | JavaScript Type |
|---------------|-----------------|
| string        | string          |
| int, float64  | number          |
| bool          | boolean         |
| struct        | object          |
| slice         | array           |
| map           | object          |
| error         | Error (thrown)  |

Return `error` as second value for error handling:
```go
func (a *App) DoWork() (Result, error) {
    if err := validate(); err != nil {
        return Result{}, err  // Frontend receives thrown error
    }
    return result, nil
}
```

## Build Process

### Step 1: Frontend Build
```bash
cd frontend
npm run build
# Output: frontend/dist/
```

### Step 2: Go Embedding
```go
//go:embed all:frontend/dist
var assets embed.FS
```

### Step 3: Wails Compilation
```bash
wails build
# Output: build/bin/app (single binary)
```

## Important Files

- **`wails.json`**: Wails project configuration
- **`main.go`**: Wails runtime configuration and startup
- **`app.go`**: Business logic exposed to frontend
- **`frontend/wailsjs/`**: Auto-generated bindings (DO NOT modify manually)

## Development Guidelines

### Adding New Backend Functionality

1. Add public method to `App` struct in `app.go`
2. Wails auto-generates TypeScript bindings
3. Import and use in React components

### Calling Backend from Frontend

```typescript
import { AnalyzeStream } from '../wailsjs/go/main/App'

try {
    const result = await AnalyzeStream(filePath)
    // Handle success
} catch (error) {
    // Handle error (from Go error return)
}
```

### Error Handling

**Backend**:
```go
func (a *App) LoadFile(path string) (Data, error) {
    if !exists(path) {
        return Data{}, fmt.Errorf("file not found: %s", path)
    }
    return data, nil
}
```

**Frontend**:
```typescript
try {
    const data = await LoadFile(path)
} catch (error) {
    console.error('Error loading file:', error)
}
```

## References

- Wails documentation: https://wails.io/docs/
- Current version: Wails v2.11.0
- Frontend framework: React 19 + TypeScript + Vite
- Backend: Go 1.23
