# Task Completion Checklist

## CRITICAL: Quality Gate (NON-NEGOTIABLE)

After ANY code modification, you MUST complete these steps before considering the task done:

### 1. Run Quality Checks
```bash
make lint
```

This runs:
- **Go**: `gofmt -l .` (formatting check) + `go vet ./...` (static analysis)
- **Frontend**: Biome linter with strict rules

**REQUIREMENT**: Zero errors. A single linter error means the task is INCOMPLETE.

### 2. Fix All Violations

If `make lint` reports any issues:
- Fix ALL violations immediately
- Re-run `make lint` to verify
- Do NOT proceed until it passes with zero errors

### 3. Run Tests (if applicable)

If tests exist for the modified code area:
```bash
make test
```

**Frontend tests**: Vitest
**Backend tests**: go test with `-race` flag for concurrency checks

### 4. Verify Build (for significant changes)

For major features or full-stack changes:
```bash
make build
```

Ensures:
- Frontend builds successfully
- Assets are embedded correctly
- Go binary compiles
- No compilation errors or warnings

### 5. Manual Validation

Test the actual functionality:
- Run the application with `make dev`
- Verify the feature works as expected
- Check for console errors or warnings
- Test edge cases from the specification

## Agent Workflow

As an agent, you MUST:

1. **After modifying code**: Run `make lint` automatically
2. **If lint fails**: Fix violations before proceeding
3. **If tests exist**: Run `make test`
4. **Report results**: Show quality check results to user transparently
5. **Never skip**: Do NOT mark task complete without passing quality gate

## Agent TDD Workflow

When implementing new features with tests:

1. **RED Phase**:
   - Write test file first with failing test cases
   - Run tests to verify they fail with expected error
   - Show user the failing test output
   - Confirm test failure message is what you expect

2. **GREEN Phase**:
   - Implement minimal feature code to make tests pass
   - Run tests again to verify they now pass
   - Show user the passing test output

3. **REFACTOR Phase**:
   - Clean up code while keeping tests green
   - Run `make lint` to ensure code quality
   - Fix any linting violations

4. **Agent MUST**:
   - Follow Red-Green-Refactor cycle explicitly
   - NOT skip the "verify tests fail" step
   - Show test output at each phase to user

## Constitution Reference

See `.specify/memory/constitution.md` for complete quality standards:
- **Principle I**: Code Quality Gate (NON-NEGOTIABLE)
- **Principle II**: Testing Standards
- **Quality Enforcement**: Agent quality workflow
- **Development Workflow**: Feature development lifecycle

## Pre-Commit Requirements

Before committing:
1. ✅ `make lint` passes with zero errors
2. ✅ `make test` passes (if tests exist)
3. ✅ No compiler warnings or type errors
4. ✅ No commented-out code blocks (or documented with TODO + issue)
5. ✅ Manual testing of user scenarios complete

## Exception Handling

**NO EXCEPTIONS** for Principle I (Code Quality Gate).

Quality checks are non-negotiable. Every code modification must pass linting.

For other principles, exceptions require:
- Explicit justification in code comments or ADR
- Issue tracking with "tech-debt" label
- Documented in the commit message

## Quick Reference

```bash
# Full quality check
make lint

# Full test suite
make test

# Complete check before commit
make lint && make test && make build
```

**Remember**: Quality gate is BLOCKING. No review, no merge, no completion until checks pass.
