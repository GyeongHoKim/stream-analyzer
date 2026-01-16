# TDD Testing Patterns

This memory contains comprehensive TDD testing patterns for both Go backend and React frontend based on official Wails and React Testing Library documentation.

## TDD Workflow (Red-Green-Refactor)

1. **RED**: Write test first, verify it fails
2. **GREEN**: Implement minimal code to make test pass
3. **REFACTOR**: Clean up code while keeping tests green

## Go Backend Testing Patterns

### 1. Direct Service Testing (Preferred)

Test Wails App struct methods directly without involving the Wails runtime:

```go
func TestGreetService(t *testing.T) {
    service := &GreetService{prefix: "Hello, "}
    result := service.Greet("Test")
    if result != "Hello, Test!" {
        t.Errorf("Expected 'Hello, Test!', got '%s'", result)
    }
}
```

**Key points**:
- No need to bind methods or start WebView
- Test business logic in isolation from UI layer
- Fast and reliable unit tests

### 2. Mock Dependencies via Interfaces

Define interfaces for external dependencies (DB, APIs, file system):

```go
type UserRepository interface {
    Create(user *User) error
    FindByEmail(email string) (*User, error)
}

type MockUserRepository struct {
    users map[string]*User
}

func (m *MockUserRepository) Create(user *User) error {
    m.users[user.Email] = user
    return nil
}

func TestUserService_WithMock(t *testing.T) {
    mock := &MockUserRepository{users: make(map[string]*User)}
    service := &UserService{repo: mock}

    _, err := service.CreateUser("test@example.com", "password123")
    if err != nil {
        t.Fatal(err)
    }

    if len(mock.users) != 1 {
        t.Error("expected 1 user in mock")
    }
}
```

**Best practices**:
- Define interface for dependency
- Create mock implementation
- Inject mock into service constructor
- Test service behavior with controlled mock data

### 3. Test Success and Error Cases

Always test both valid and invalid inputs:

```go
func TestUserService_CreateUser(t *testing.T) {
    db := &MockDB{}
    service := &UserService{db: db}

    // Success case
    user, err := service.CreateUser("test@example.com", "password123")
    if err != nil {
        t.Fatalf("unexpected error: %v", err)
    }

    // Error cases
    _, err = service.CreateUser("invalid", "password123")
    if err == nil {
        t.Error("expected error for invalid email")
    }

    _, err = service.CreateUser("test@example.com", "short")
    if err == nil {
        t.Error("expected error for short password")
    }
}
```

**Coverage areas**:
- Valid inputs → expected results
- Invalid inputs → appropriate errors
- Boundary conditions and edge cases

### 4. File Organization

- Place tests in `<feature>_test.go` next to `<feature>.go`
- Use `testdata/` directory for test fixtures
- Run with race detector: `go test -v -race ./...`

## React Frontend Testing Patterns

### 1. Arrange-Act-Assert Pattern

Standard pattern for all component tests:

```typescript
import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import '@testing-library/jest-dom'

test('loads and displays greeting', async () => {
  // ARRANGE
  render(<Fetch url="/greeting" />)

  // ACT
  await userEvent.click(screen.getByText('Load Greeting'))
  await screen.findByRole('heading')

  // ASSERT
  expect(screen.getByRole('heading')).toHaveTextContent('hello there')
  expect(screen.getByRole('button')).toBeDisabled()
})
```

### 2. Query Elements by Accessibility

**Query Priority** (use in this order):

1. `getByRole` - Best (matches how users/assistive tech find elements)
2. `getByLabelText` - Forms with labels
3. `getByPlaceholderText` - Form inputs
4. `getByText` - Non-interactive elements
5. `getByTestId` - Last resort (add `data-testid` only when needed)

**Query Variants**:
- `getBy...` - Returns element or throws (single element expected)
- `queryBy...` - Returns element or null (use when asserting element doesn't exist)
- `findBy...` - Returns promise, waits for element (async operations)

```typescript
// Use screen for all queries (scoped to document.body)
const button = screen.getByRole('button', { name: 'Submit' })
const heading = await screen.findByRole('heading') // Wait for async
const missing = screen.queryByText('Not here') // null if not found
```

### 3. Simulate User Interactions

Use `@testing-library/user-event` for realistic interactions:

```typescript
import { render, screen, fireEvent } from '@testing-library/react'

test('examples of some things', async () => {
  render(<Example />)

  // Simulate typing
  fireEvent.changeText(screen.getByTestId('input'), 'Ada Lovelace')

  // Simulate click
  fireEvent.press(screen.getByText('Submit'))

  // Wait for async operation
  const output = await screen.findByTestId('output')
  expect(output).toHaveTextContent('Ada Lovelace')
})
```

**Best practices**:
- Use `userEvent` for realistic user interactions
- Use `fireEvent` only for events `userEvent` doesn't support
- Always wait for async updates with `findBy` or `waitFor`

### 4. Mock Wails Backend Calls

Mock Wails-generated bindings in tests:

```typescript
// Mock Wails bindings
jest.mock('../wailsjs/go/main/App', () => ({
  AnalyzeStream: jest.fn()
}))

test('displays analysis results', async () => {
  const mockData = { nalUnits: [...] }
  AnalyzeStream.mockResolvedValue(mockData)

  render(<StreamAnalyzer />)
  await userEvent.click(screen.getByText('Analyze'))

  expect(await screen.findByText('NAL Units: 10')).toBeInTheDocument()
})
```

**Test different states**:
- Loading state (backend call in progress)
- Success state (data returned)
- Error state (backend throws error)
- Empty state (no data returned)

### 5. Test Component States

Always test all possible component states:

```typescript
test('shows loading state', async () => {
  AnalyzeStream.mockImplementation(() => new Promise(() => {})) // Never resolves
  render(<StreamAnalyzer />)
  
  await userEvent.click(screen.getByText('Analyze'))
  expect(screen.getByText('Loading...')).toBeInTheDocument()
})

test('shows error state', async () => {
  AnalyzeStream.mockRejectedValue(new Error('Parse failed'))
  render(<StreamAnalyzer />)
  
  await userEvent.click(screen.getByText('Analyze'))
  expect(await screen.findByText('Parse failed')).toBeInTheDocument()
})
```

### 6. File Organization

- Place tests in `<Component>.test.tsx` next to `<Component>.tsx`
- Use `__tests__/fixtures/` for test data
- Create `frontend/src/test-utils.ts` for custom render functions

## Testing Anti-Patterns to AVOID

❌ **Don't test implementation details**:
- Internal state
- Private methods
- Component lifecycle methods

❌ **Don't use `getByTestId` when accessible queries work**:
```typescript
// Bad
screen.getByTestId('submit-button')

// Good
screen.getByRole('button', { name: 'Submit' })
```

❌ **Don't forget to wait for async operations**:
```typescript
// Bad - race condition!
fireEvent.click(button)
expect(screen.getByText('Result')).toBeInTheDocument()

// Good - wait for async update
fireEvent.click(button)
expect(await screen.findByText('Result')).toBeInTheDocument()
```

❌ **Don't test multiple concerns in one test**:
```typescript
// Bad - tests form validation AND submission
test('form works', () => { /* ... */ })

// Good - separate concerns
test('shows error for invalid email', () => { /* ... */ })
test('submits form with valid data', () => { /* ... */ })
```

## Quick Reference Commands

```bash
# Run all tests (Go + Frontend)
make test

# Run Go tests with race detector
make test-go
# or
go test -v -race ./...

# Run frontend tests
make test-frontend
# or
cd frontend && npm test

# Run tests in watch mode (frontend)
cd frontend && npm test -- --watch

# Run specific test file
cd frontend && npm test -- Component.test.tsx

# Run with coverage
cd frontend && npm test -- --coverage
```

## Constitution Reference

See `.specify/memory/constitution.md` Principle II: Testing Standards & TDD Discipline for complete governance rules.
