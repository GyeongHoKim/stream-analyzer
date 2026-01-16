# Suggested Commands

## Essential Development Commands

### Installation
```bash
# Install all dependencies (Go modules + npm packages)
make install
```

### Development
```bash
# Run development server with hot reload (Wails + Vite)
make dev
```

### Building
```bash
# Build production binary (output: build/bin/app)
make build
```

### Quality Checks (CRITICAL)
```bash
# Run ALL quality checks (Go + Frontend)
make lint

# Run Go checks only
make lint-go

# Run frontend checks only
make lint-frontend
```

### Testing
```bash
# Run all tests (Go + Frontend)
make test

# Run Go tests only (with race detector)
make test-go

# Run frontend tests only (Vitest)
make test-frontend
```

### Cleaning
```bash
# Clean build artifacts and dependencies
make clean
```

### Help
```bash
# Show all available commands
make help
```

## Frontend-Specific Commands

```bash
cd frontend

# Run Vite dev server
npm run dev

# Build frontend (TypeScript + Vite)
npm run build

# Run Biome linter (auto-fixes issues)
npm run lint

# Run Biome formatter
npm run format

# Run Vitest tests
npm test

# Preview production build
npm run preview

# Add shadcn/ui component
npx shadcn@latest add [component-name]
```

## Backend-Specific Commands

```bash
# Format Go code
gofmt -w .

# Check Go formatting (no output = good)
gofmt -l .

# Run Go static analyzer
go vet ./...

# Run Go tests with race detector and coverage
go test -v -race -coverprofile=coverage.out ./...

# Download Go dependencies
go mod download
```

## Git Commands (macOS/Darwin)

```bash
# Standard git commands work normally on Darwin
git status
git add .
git commit -m "message"
git push
git pull
```

## System Commands (macOS/Darwin)

```bash
# List files
ls -la

# Find files (use Serena's find_file tool instead when possible)
find . -name "*.ts"

# Search in files (use Serena's search_for_pattern tool instead when possible)
grep -r "pattern" .

# Change directory
cd path/to/directory

# Print working directory
pwd

# View file contents (use Serena's Read tool instead)
cat file.txt
```

## Important Notes

- **Quality Gate**: Always run `make lint` after code changes (see task_completion_checklist.md)
- **Testing**: Run `make test` before committing if tests exist
- **Darwin-Specific**: macOS commands are standard Unix/BSD commands
- **Wails**: Use `wails dev` directly or via `make dev` for hot reload
- **shadcn/ui**: Always use `npx shadcn@latest add` to add new components
