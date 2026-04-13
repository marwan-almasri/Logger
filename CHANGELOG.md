# Changelog

All notable changes to the Logger package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- List new features here

### Changed
- List changes to existing functionality

### Deprecated
- List soon-to-be removed features

### Removed
- List removed features

### Fixed
- List bug fixes

### Security
- List security fixes

## [1.0.0] - 2025-04-13

### Added
- Thread-safe Logger implementation with Sendable conformance
- Serial dispatch queue synchronization for atomic operations
- Lock-protected mutable state (isEnabled, redactKeys)
- ConsoleLogger for stdout output
- FileLogger for file-based logging
- LoggerBuilder with fluent API
- MockLoggerOutput for testing
- Comprehensive test suite with concurrent stress tests
- Documentation in CLAUDE.md and CONTRIBUTING.md

### Features
- ✅ Multiple log levels (info, success, warning, error)
- ✅ Metadata support with case-insensitive redaction
- ✅ Async output dispatching (no blocking)
- ✅ Configurable via builder pattern
- ✅ Thread-safe across concurrent access
- ✅ Fully testable with mocks

---

## Versioning

### Version Numbers

Follow [Semantic Versioning](https://semver.org/):

- **MAJOR** — Breaking API changes
- **MINOR** — New features, backward compatible
- **PATCH** — Bug fixes, backward compatible

### Release Steps

1. Update version in `Package.swift`
2. Update this `CHANGELOG.md` file
3. Update `README.md` if needed
4. Commit changes: `git commit -am "chore: bump version to X.Y.Z"`
5. Create git tag: `git tag vX.Y.Z`
6. Push: `git push origin main --tags`
7. Create GitHub Release with changelog excerpt

### Example Release Commit

```
git tag v1.1.0
git push origin main --tags

# GitHub will automatically create a release
```
