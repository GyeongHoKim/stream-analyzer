# Code Style and Conventions

## Frontend (TypeScript/React)

### Biome Configuration

The project uses **Biome** with strict linting rules. All rules are configured in `frontend/biome.json`.

#### Formatting Rules
- **Indentation**: Tabs (not spaces)
- **Quote Style**: Double quotes (not single)
- **Auto-organize imports**: Enabled

#### Key Linting Rules (Error Level)

**Prohibited Patterns**:
- `var` keyword (use `const` or `let`)
- `any` type in TypeScript
- Unused variables
- Duplicate class members, object keys, parameters
- Empty block statements
- Fallthrough switch cases
- Debugger statements

**Required Patterns**:
- Use `const` for non-reassigned variables
- Exhaustive dependencies in `useEffect` (warning level)
- Hooks must be at top level
- Use `as const` assertions where appropriate
- Use namespace keyword (not `module`)

#### TypeScript-Specific
- No explicit `any` type
- No unused type constraints
- No extra non-null assertions
- No misleading instantiator
- Array literals preferred over constructors

### React Conventions
- **Hooks**: Must be at top level (enforced)
- **Dependencies**: Exhaustive dependencies in hooks (warning - will show but not fail)
- **UI Components**: Must use shadcn/ui library (New York variant)
- **Icons**: Lucide React only
- **Styling**: Tailwind CSS classes with `cn()` utility for merging

### Path Aliases (configured in `components.json`)
- `@/components` → `src/components`
- `@/components/ui` → `src/components/ui` (shadcn components)
- `@/lib/utils` → `src/lib/utils`
- `@/hooks` → `src/hooks`

## Backend (Go)

### Go Formatting
- **Tool**: gofmt (standard Go formatter)
- **Enforcement**: Code must pass `gofmt -l .` check (no output = formatted)

### Go Linting
- **Tool**: go vet (standard Go static analyzer)
- **Enforcement**: All warnings must be fixed

### Go Conventions
- Follow standard Go naming conventions
- Exported functions and types must be documented
- Wails binding methods in `app.go` should be clear and well-documented

## Naming Conventions

### General
- Prefer clear, descriptive names over comments
- Function/method names should describe what they do
- Variable names should describe what they contain

### TypeScript/React
- **Components**: PascalCase (e.g., `VideoAnalyzer`, `NalUnitTree`)
- **Functions**: camelCase (e.g., `parseNalUnit`, `decodeFrame`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `MAX_FILE_SIZE`)
- **Types/Interfaces**: PascalCase (e.g., `NalUnitData`, `VideoStream`)

### Go
- **Exported**: PascalCase (e.g., `ParseStream`, `NalUnit`)
- **Unexported**: camelCase (e.g., `parseHeader`, `nalUnit`)

## Documentation

### When to Document
- Complex algorithms (e.g., NAL unit parsing logic)
- Non-obvious business rules (e.g., H.264 spec interpretations)
- Public APIs and exported Go functions
- Wails binding methods called from frontend

### When NOT to Document
- Obvious code ("increments counter")
- Implementation details explained by the code itself
- Temporary debugging notes (remove before commit)

## File Organization

### Frontend
```
src/
├── components/     # React components
│   └── ui/        # shadcn/ui components (do not modify directly)
├── lib/           # Utilities (including cn() function)
├── hooks/         # Custom React hooks
└── ...
```

### Backend
```
./                 # Root directory
├── main.go        # Application entry point
├── app.go         # App struct with Wails-bound methods
└── ...
```
