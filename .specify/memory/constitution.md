<!--
SYNC IMPACT REPORT
==================
Version Change: 1.0.0 → 1.1.1
Modified Principles:
  - Principle II: Testing Standards → Condensed to core principles, moved detailed patterns to Serena memory
Added Sections:
  - Brief Unit Testing Best Practices (under Principle II)
Removed Sections:
  - Detailed code examples moved to `.serena/stream-analyzer/memories/tdd_testing_patterns.md`
Templates Requiring Updates:
  ✅ plan-template.md - Constitution Check section already references constitution file dynamically
  ✅ spec-template.md - User scenarios and requirements already align with testing principles
  ✅ tasks-template.md - Task categorization and quality checkpoints already support principles
  ✅ agent-file-template.md - Updated with Quality Gate section referencing constitution
Serena Memories:
  ✅ tdd_testing_patterns.md - Contains comprehensive code examples and patterns
  ✅ task_completion_checklist.md - Updated with TDD workflow
Follow-up TODOs: None
Rationale for PATCH bump: Clarification and reorganization - moved verbose code examples to Serena memory while preserving core principles.
-->

# Stream Analyzer Constitution

## Core Principles

### I. Code Quality Gate (NON-NEGOTIABLE)

**Rule**: All code modifications MUST pass the quality gate before being considered complete. The agent MUST run `make lint` after any code changes and fix all violations before proceeding.

**Requirements**:
- **Go code**: Must pass `gofmt` formatting check and `go vet` static analysis with zero errors
- **Frontend code**: Must pass Biome linter with strict rules (no `var`, no `any`, no unused variables, exhaustive dependencies in hooks)
- **Zero tolerance**: A single linter error means the task is incomplete
- **Agent responsibility**: The agent MUST automatically run quality checks after code modifications, not wait for user request

**Rationale**: Quality gates prevent technical debt accumulation and ensure consistent code style. Running checks as part of the development workflow (not as an afterthought) catches issues early when they're cheapest to fix. This principle reflects the project's commitment to maintainability over speed.

### II. Testing Standards & TDD Discipline

**Rule**: Tests are written FIRST, must FAIL before implementation, then implementation makes them pass (Red-Green-Refactor).

**Requirements**:
- **Test-Driven Development**: When tests are part of the feature specification, tests MUST be written before implementation code
- **Verification**: Agent MUST verify tests fail with expected failure before writing implementation
- **Coverage areas**:
  - **Unit tests**: Individual function/component behavior (Vitest for frontend, `go test` for backend)
  - **Integration tests**: Component interactions and data flow
  - **Contract tests**: API endpoint contracts and data shapes (when applicable)
- **Test quality**: Tests must be independent, repeatable, and test one concern at a time
- **Race conditions**: Go tests MUST run with `-race` flag to detect concurrency issues

**Rationale**: TDD ensures code is testable by design and requirements are clear before implementation. Failing tests first proves tests actually validate the behavior. This discipline prevents untested code and reduces debugging time.

#### Unit Testing Best Practices

**Go Backend Testing**:
- Test Wails App struct methods directly without involving Wails runtime
- Mock external dependencies via interfaces (DB, APIs, file system)
- Test both success cases (valid inputs) and error cases (invalid inputs, boundary conditions)
- Place tests in `<feature>_test.go` adjacent to `<feature>.go`

**React Frontend Testing**:
- Use Arrange-Act-Assert pattern consistently
- Query elements by accessibility (`getByRole` preferred over `getByTestId`)
- Simulate user interactions with `@testing-library/user-event`
- Mock Wails backend bindings to test component behavior with various backend states
- Test all component states: initial, loading, success, error, empty
- Place tests in `<Component>.test.tsx` adjacent to `<Component>.tsx`

**Testing Anti-Patterns to Avoid**:
- ❌ Testing implementation details (internal state, private methods)
- ❌ Using `getByTestId` when accessible queries work
- ❌ Not waiting for async operations (causes flaky tests)
- ❌ Testing multiple concerns in one test
- ✅ Test user-observable behavior
- ✅ Keep tests simple and readable

**Detailed Patterns**: Agents should consult Serena memory `tdd_testing_patterns.md` for comprehensive code examples and testing patterns based on official Wails and React Testing Library documentation.

### III. UI/UX Consistency

**Rule**: All user interface components MUST use shadcn/ui library with the New York variant. Custom UI code is prohibited unless shadcn/ui lacks the required component.

**Requirements**:
- **Component source**: Use `npx shadcn@latest add [component-name]` for all UI components
- **Icons**: Use Lucide React icons exclusively (from `lucide-react` package)
- **Styling**: Use Tailwind CSS classes; use `cn()` utility from `@/lib/utils` for class merging
- **Path aliases**:
  - `@/components` → `src/components`
  - `@/components/ui` → `src/components/ui` (shadcn components)
  - `@/lib/utils` → `src/lib/utils`
  - `@/hooks` → `src/hooks`
- **Customization**: If shadcn component needs modification, extend it via composition or wrapper components, never modify the component in `@/components/ui` directly
- **Accessibility**: Components must maintain WCAG 2.1 AA compliance (shadcn/ui components are accessible by default)

**Rationale**: Using a consistent, professionally designed component library ensures visual consistency, accessibility, and maintainability. shadcn/ui components are built with best practices and eliminate the need to reinvent common UI patterns. This reduces cognitive load for users and developers.

### IV. Performance & Reliability

**Rule**: Desktop application performance MUST meet baseline standards for video analysis tools. The application must handle real-world video streams without crashes or data corruption.

**Requirements**:
- **Startup time**: Application must be interactive within 3 seconds of launch
- **File loading**: Support H.264/H.265 files up to 500MB without UI freeze (use background workers)
- **Memory management**:
  - Limit memory footprint to <500MB for typical streams (<100MB file size)
  - Implement pagination/virtualization for large NAL unit lists (>1000 units)
- **Frame rendering**: Decode and display frames within 200ms for smooth navigation
- **Error handling**: Never crash on malformed streams; display clear error messages and allow continued analysis of valid portions
- **Background processing**: Long operations (parsing, decoding) must run in Web Workers (frontend) or goroutines (backend) with progress indication

**Rationale**: Video analysis tools handle large, complex binary data. Poor performance or crashes destroy user trust and productivity. These standards ensure the tool remains responsive and reliable even with challenging input files.

### V. Documentation Standards

**Rule**: Code must be self-documenting through clear naming. Documentation is required only where behavior is non-obvious or where it aids future maintenance.

**Requirements**:
- **Code clarity**: Prefer clear variable/function names over comments
- **When to document**:
  - Complex algorithms (e.g., NAL unit parsing logic)
  - Non-obvious business rules (e.g., H.264 spec interpretations)
  - Public APIs and exported Go functions
  - Wails binding methods called from frontend
- **What NOT to document**:
  - Obvious code ("increments counter")
  - Implementation details explained by the code itself
  - Temporary debugging notes (remove before commit)
- **Architecture decisions**: Document in `CLAUDE.md` or separate ADR (Architecture Decision Record) files for significant technical choices
- **User-facing docs**: README, feature documentation, and quickstart guides must be updated when user-visible behavior changes

**Rationale**: Over-documentation creates maintenance burden (docs drift from code). Under-documentation makes code impenetrable. This principle balances clarity with pragmatism: document the "why" and complex "how", let code explain the simple "what".

## Quality Enforcement

**Pre-Commit Requirements**:
1. All code changes MUST pass `make lint` (frontend Biome + Go gofmt/vet)
2. All tests MUST pass `make test` (Vitest + go test)
3. No new compiler warnings or type errors
4. No commented-out code blocks (remove or explain with TODO + issue reference)

**Agent Quality Workflow**:
1. After modifying any code file, agent MUST run `make lint`
2. If lint fails, agent MUST fix all violations before proceeding
3. If tests exist for the modified area, agent MUST run `make test`
4. Agent may NOT mark task complete until quality checks pass
5. Agent MUST report quality check results to user transparently

**Agent TDD Workflow**:
1. When implementing new features with tests:
   - Write test file first with failing test cases
   - Run tests to verify they fail with expected error
   - Show user the failing test output
   - Implement feature code to make tests pass
   - Run tests again to verify they now pass
   - Show user the passing test output
2. Agent MUST follow Red-Green-Refactor cycle explicitly
3. Agent MUST NOT skip the "verify tests fail" step

**Enforcement Level**: Blocking - no code review or merge until quality gates pass.

## Development Workflow

**Feature Development Lifecycle**:
1. **Specification**: Define user scenarios and acceptance criteria (see spec-template.md)
2. **Planning**: Identify technical approach and file structure (see plan-template.md)
3. **Implementation** (TDD cycle):
   - **RED**: Write tests first, verify they fail
   - **GREEN**: Implement minimal code to make tests pass
   - **REFACTOR**: Clean up code while keeping tests green
   - Run quality gate (`make lint`)
   - Fix any violations
4. **Validation**: Manual testing of user scenarios from specification
5. **Commit**: Create git commit only after all quality checks pass

**Wails-Specific Guidelines**:
- Backend changes (Go): Modify `app.go` methods, ensure Wails bindings are accessible to frontend
- Frontend changes (React): Use auto-generated Wails bindings to call Go backend
- Full-stack features: Implement backend method first (with tests), then frontend UI (with tests)
- Build validation: Run `make build` to verify embedding and binary creation before considering feature complete
- Testing: Backend and frontend are tested independently; integration tests verify Wails bindings work

**Incremental Delivery**:
- Features should be broken into independently testable user stories (P1, P2, P3 priorities)
- Each user story should be deployable independently when possible
- Prefer small, frequent commits over large batch commits
- Use feature branches for non-trivial work

## Governance

**Authority**: This constitution supersedes all other development practices and conventions. When conflicts arise between this document and other guidance, this document takes precedence.

**Amendment Process**:
1. **Proposal**: Document proposed change with rationale and impact analysis
2. **Validation**: Ensure proposed change aligns with project goals (video stream analysis tool quality and maintainability)
3. **Migration**: If amendment changes existing code patterns, create migration plan
4. **Versioning**: Update constitution version following semantic versioning:
   - **MAJOR**: Backward-incompatible governance changes or principle removal
   - **MINOR**: New principles added or material expansions to existing principles
   - **PATCH**: Clarifications, wording improvements, typo fixes

**Compliance Review**:
- Every code modification MUST be reviewed against Principles I (Code Quality Gate) and II (Testing Standards & TDD)
- UI changes MUST be reviewed against Principle III (UI/UX Consistency)
- Performance-sensitive changes MUST be reviewed against Principle IV (Performance & Reliability)
- Agents MUST reference this constitution when making technical decisions
- Users may request constitution compliance check at any time via `/speckit.constitution`

**Exception Handling**:
- Exceptions to principles require explicit justification documented in code comments or ADR
- Technical debt incurred by exceptions MUST be tracked in issues with "tech-debt" label
- No exceptions permitted for Principle I (Code Quality Gate) - quality checks are non-negotiable

**Runtime Development Guidance**:
- Agents should consult `CLAUDE.md` for project-specific development commands and architecture patterns
- When `CLAUDE.md` conflicts with this constitution, constitution wins; `CLAUDE.md` should be updated to align

**Version**: 1.1.1 | **Ratified**: 2026-01-17 | **Last Amended**: 2026-01-17
