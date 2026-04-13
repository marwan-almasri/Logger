# Quick Start Guide for Logger Package Development

## First Time Setup

```bash
cd Logger
./scripts/setup-dev.sh
```

This will verify dependencies and run initial tests.

## Daily Workflow

### Before Making Changes

```bash
# Update main
git checkout main
git pull origin main

# Create feature branch
git checkout -b feature/your-feature-name
```

### While Developing

```bash
# Build
swift build

# Run tests
swift test

# Check code style
make lint

# Auto-format code
make format
```

### Before Committing

```bash
# Run all checks
make all

# This runs: test + lint + coverage
# Pre-commit hook will run automatically when you commit
```

### After Finishing

```bash
# Push branch
git push origin feature/your-feature-name

# Open PR on GitHub
# Link any related issues: "Fixes #123"
```

## Common Tasks

| Task | Command |
|------|---------|
| Run tests | `swift test` |
| Run with verbose output | `swift test -v` |
| Run specific test | `swift test --filter TestName` |
| Check code style | `make lint` |
| Auto-format code | `make format` |
| Generate coverage | `make coverage` |
| Run all checks | `make all` |
| Clean build | `make clean` |
| View help | `make help` |

## Debugging

### Run a Single Test

```bash
swift test --filter loggerIsThreadSafe
```

### Run Tests Interactively

```bash
swift test -v
```

### Check Lint Issues

```bash
swiftlint lint
```

### Build in Release Mode

```bash
swift build -c release
```

## File Locations

| Purpose | File |
|---------|------|
| Package config | `Package.swift` |
| Architecture docs | `CLAUDE.md` |
| Contributing guide | `CONTRIBUTING.md` |
| Changelog | `CHANGELOG.md` |
| CI/CD pipeline | `.github/workflows/test.yml` |
| Issue templates | `.github/ISSUE_TEMPLATE/` |
| Pre-commit hook | `.git/hooks/pre-commit` |
| Code style config | `.swiftlint.yml` |

## Key Concepts

### Thread-Safety

All public types must be `Sendable` and thread-safe. Use:
- `NSLock.withLock { }` for state protection
- `DispatchQueue.sync { }` for serialization
- Add concurrent tests for verification

### Testing

Every change needs tests:
- Unit tests for logic
- Integration tests for I/O
- Concurrent tests for thread-safety
- Mock objects instead of real implementations

### Documentation

Update docs when changing:
- Public API → README.md
- Architecture → CLAUDE.md
- Contributing guidelines → CONTRIBUTING.md
- Release notes → CHANGELOG.md

## Troubleshooting

### SwiftLint Issues

```bash
# Fix automatically
swiftformat .

# See all issues
swiftlint lint
```

### Test Failures

```bash
# Run with verbose output
swift test -v

# Run specific test
swift test --filter FailingTest

# Check thread safety
swift test --filter threadSafe
```

### Build Fails

```bash
# Clean and rebuild
make clean
swift build

# Check Swift version
swift --version
```

### Pre-commit Hook Issues

```bash
# Check hook status
cat .git/hooks/pre-commit

# Make executable
chmod +x .git/hooks/pre-commit

# Bypass for emergency (not recommended)
git commit --no-verify
```

## Git Workflow Summary

```
main
  └── feature/your-feature-name (your work)
      ├── commit 1: feat: add new output type
      ├── commit 2: test: add concurrent tests
      └── commit 3: docs: update CLAUDE.md
         │
         └── Pull Request → Review → Merge to main
```

## Code Review Expectations

Your PR will be checked for:

1. ✅ All tests pass
2. ✅ Code passes linting
3. ✅ Thread-safety (if applicable)
4. ✅ Documentation updated
5. ✅ Commit messages follow format
6. ✅ No merge conflicts

## Need Help?

- Check [CLAUDE.md](../CLAUDE.md) for architecture
- Check [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines
- Review existing tests for patterns
- Look at recent commits for style examples

---

**Happy coding! 🚀**
