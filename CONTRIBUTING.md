# Contributing to Logger

Thank you for your interest in contributing to the Logger package! This guide will help you get started.

## Getting Started

### Prerequisites

- Swift 5.7+
- Xcode 16.0+ (or Command Line Tools)
- macOS 10.15+ or iOS 13+

### Local Development Setup

```bash
# Clone the repository
git clone https://github.com/marwan-almasri/Logger.git
cd Logger

# Verify setup
swift --version
swift test

# Format code
make format

# Run linter
make lint

# Run all checks
make all
```

## Development Workflow

### 1. Create a Feature Branch

```bash
git checkout -b feature/your-feature-name
# or for bugs:
git checkout -b fix/bug-description
```

Branch naming convention:
- `feature/` — New functionality
- `fix/` — Bug fixes
- `refactor/` — Code reorganization (no behavior change)
- `docs/` — Documentation improvements
- `chore/` — Maintenance, dependencies

### 2. Make Your Changes

Follow the guidelines in [CLAUDE.md](CLAUDE.md), specifically:

- **Keep changes focused** — One feature/fix per branch
- **Maintain thread-safety** — All mutable state must be protected
- **Add tests** — New functionality requires corresponding tests
- **Follow code style** — SwiftLint must pass (run `make lint`)
- **Update documentation** — Update CLAUDE.md if architectural changes are made

### 3. Test Locally

```bash
# Run all tests with coverage
swift test --enable-code-coverage

# Run specific test suite
swift test --filter LoggerTests.loggerIsThreadSafe

# Run with verbose output
swift test -v

# Check code style
make lint

# Auto-format code
make format
```

### 4. Commit Your Changes

#### Commit Message Format

```
<type>: <subject>

<body>

<footer>
```

**Example:**

```
feat: add network logger output for remote logging

Implements a new NetworkLogger that sends logs to a remote server
via HTTP POST. Includes exponential backoff retry logic and
automatic batching for high-throughput scenarios.

Implements: #42
Co-Authored-By: Claude Haiku 4.5 <noreply@anthropic.com>
```

**Types:**
- `feat` — New feature
- `fix` — Bug fix
- `refactor` — Code reorganization (no behavior change)
- `docs` — Documentation
- `test` — Test additions/modifications
- `chore` — Maintenance, dependencies

**Guidelines:**
- Subject line: present tense, lowercase, 50 chars max
- Body: explain _what_ and _why_, not _how_ (code shows how)
- Reference related issues: `Fixes #123` or `Implements #456`
- Always add: `Co-Authored-By: Claude Haiku 4.5 <noreply@anthropic.com>` if using Claude

### 5. Push and Create a Pull Request

```bash
git push origin feature/your-feature-name
```

Then open a PR on GitHub with a clear title and description.

#### Pull Request Checklist

Before submitting, ensure:

- [ ] All tests pass (`swift test`)
- [ ] Code passes linting (`make lint`)
- [ ] Code is formatted (`make format`)
- [ ] New code has corresponding tests
- [ ] Thread-safety is documented if mutable state is involved
- [ ] CLAUDE.md is updated for architectural changes
- [ ] README.md examples are updated if API changed
- [ ] Commit messages follow the format above
- [ ] No merge conflicts with `main`

## Code Standards

### Thread-Safety Requirements

All new components must be thread-safe:

1. **Shared mutable state** must be protected by:
   - `NSLock` with `.withLock { }` pattern, or
   - Serial `DispatchQueue` with `.sync { }` pattern

2. **Public types** should conform to `Sendable`:
   ```swift
   public struct MyOutput: LoggerOutput, Sendable {
       // ...
   }
   ```

3. **Thread-safety tests** required for any state mutation:
   ```swift
   @Test func myFeatureIsThreadSafe() {
       let group = DispatchGroup()
       for i in 0..<10 {
           DispatchQueue.global().async(group: group) {
               // concurrent access
           }
       }
       group.wait()
       // verify results
   }
   ```

### Testing Requirements

- **Unit tests** for all public APIs
- **Integration tests** for output implementations
- **Concurrent tests** for thread-safety
- **Mock usage** — Test using MockLoggerOutput, not real outputs
- **Coverage target** — Aim for 80%+

Example test structure:

```swift
import Testing
@testable import Logger
import LoggerMocks

@Suite("MyFeature tests")
struct MyFeatureTests {
    
    @Test func happyPath() {
        let mockOutput = MockLoggerOutput()
        let logger = Logger(outputs: [mockOutput])
        
        logger.info("test")
        
        #expect(mockOutput.messages.count == 1)
        #expect(mockOutput.messages.first?.level == .info)
    }
    
    @Test func threadSafe() {
        // concurrent test
    }
}
```

### Code Style

- **Imports:** Foundation/stdlib first, then local imports
- **Access control:** `private` by default, mark public explicitly
- **Naming:** Swift conventions (camelCase for properties/methods, PascalCase for types)
- **Documentation:** Docstrings for all public types/methods
- **Line length:** Max 120 characters (SwiftLint enforced)

SwiftLint configuration is in `.swiftlint.yml`. Run `make lint` to check, `make format` to auto-fix.

## Adding New Output Implementations

When adding a new log output (e.g., Syslog, Analytics, Slack):

1. Create a new file in `Sources/Logger/`
2. Conform to `LoggerOutput` and `Sendable`
3. Use `DispatchQueue` for async operations
4. Add comprehensive tests (sync, async, concurrent)
5. Update CLAUDE.md with example usage
6. Update README.md if public-facing

Example:

```swift
// Sources/Logger/AnalyticsLogger.swift
import LoggerInterface
import Foundation

public struct AnalyticsLogger: LoggerOutput, Sendable {
    private let eventService: EventService
    private let queue: DispatchQueue

    public init(eventService: EventService) {
        self.eventService = eventService
        self.queue = DispatchQueue(label: "com.logger.analyticsLogger")
    }

    public func log(message: String, level: LogLevel, redactedMetadata: [String: String]?) {
        queue.async {
            self.eventService.track(event: "log", properties: [
                "level": level.rawValue,
                "message": message,
                "metadata": redactedMetadata ?? [:]
            ])
        }
    }
}
```

## Reviewing Changes

### For Reviewers

When reviewing PRs, check:

1. **Thread-safety** — Is all mutable state protected?
2. **Testing** — Are edge cases tested? Concurrent access verified?
3. **Documentation** — Is CLAUDE.md updated? Are examples clear?
4. **API stability** — Do changes break backward compatibility?
5. **Performance** — Could this impact logging throughput?

### For Authors

Respond to feedback promptly and:

- Update code based on feedback
- Re-request review after changes
- Add comments explaining complex logic
- Link to related issues/discussions

## Documentation

### Updating CLAUDE.md

When making architectural changes:

1. Update the relevant section
2. Add/remove examples if needed
3. Update the "Current State & Future Considerations" section
4. Run `make docs` to verify formatting (if doc builder exists)

### Updating README.md

If API changes affect user-facing functionality:

1. Update usage examples
2. Add new output types to the table
3. Update installation version if needed

## Reporting Issues

Use GitHub Issues to report bugs or request features.

### Bug Report Template

```markdown
## Description
Brief description of the issue.

## Steps to Reproduce
1. ...
2. ...
3. ...

## Expected Behavior
What should happen.

## Actual Behavior
What actually happens.

## Environment
- Swift version: 5.10
- Platform: macOS/iOS
- Logger version: 1.0.0

## Logs / Error Output
```
Paste relevant logs or error traces.
```
```

### Feature Request Template

```markdown
## Description
Clear description of the feature.

## Use Case
Why is this needed? What problem does it solve?

## Proposed Solution
How should this work?

## Alternatives Considered
Other approaches you've thought of.
```

## Release Process

1. Update version in `Package.swift` and `README.md`
2. Update `CHANGELOG.md` (if it exists) with changes
3. Create a git tag: `git tag v1.0.0`
4. Push tag: `git push origin v1.0.0`
5. Create GitHub Release with release notes

## Questions?

- Check [CLAUDE.md](CLAUDE.md) for architecture and design decisions
- Review existing tests for usage patterns
- Look at recent commits for style examples
- Open a GitHub Discussion for questions

## Code of Conduct

- Be respectful and inclusive
- Welcome diverse perspectives
- Focus on code quality and collaborative improvement
- Report inappropriate behavior to maintainers

Thank you for contributing! 🙏
