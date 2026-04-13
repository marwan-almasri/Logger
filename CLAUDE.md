# Logger Swift Package - Project Guide

## Overview

**Logger** is a thread-safe, extensible logging framework for Swift applications targeting iOS 13+ and macOS 10.15+. It provides a plugin-based architecture for flexible log output handling with built-in support for metadata redaction and log level filtering.

### Package Structure

The package is organized into three main libraries:

- **LoggerInterface** — Pure protocol definitions (LoggerProtocol, LoggerOutput, LogLevel, LoggerConfiguration)
- **Logger** — Core implementations (Logger class, ConsoleLogger, FileLogger, LoggerBuilder)
- **LoggerMocks** — Testing utilities for downstream projects (MockLogger, MockLoggerOutput, MockLoggerBuilder)

## Architecture

### Core Components

#### LoggerProtocol
The main logging interface. Implementations must be thread-safe and can be accessed concurrently.

```swift
protocol LoggerProtocol {
    func log(_ message: String, level: LogLevel, metadata: [String: String]?)
    func info(_ message: String, metadata: [String: String]?)
    func success(_ message: String, metadata: [String: String]?)
    func warning(_ message: String, metadata: [String: String]?)
    func error(_ message: String, metadata: [String: String]?)
}
```

#### LoggerOutput
Defines how logs should be written by output targets. Each output implementation must be `Sendable`.

```swift
protocol LoggerOutput: Sendable {
    func log(message: String, level: LogLevel, redactedMetadata: [String: String]?)
}
```

#### LogLevel
Four severity levels with emoji symbols, ordered: info (0) → success (1) → warning (2) → error (3).

- `.info` — ℹ️ 🔵
- `.success` — ✅ 🟢
- `.warning` — ⚠️ 🟡
- `.error` — ⛔️ 🔴

### Logger Implementation

**Thread-safe, Sendable logger class with:**
- Serial dispatch queue (`com.logger.logger`) for atomic operations
- Lock-protected mutable properties (`isEnabled`, `redactKeys`)
- Async output dispatching (console/file loggers run on their own queues)
- Timestamp formatting in `yyyy-MM-dd HH:mm:ss.SSS` format (en_US_POSIX locale)
- Thread identification (main vs background)

**Key properties:**
- `isEnabled: Bool` — Master on/off switch (default: true)
- `redactKeys: Set<String>?` — Case-insensitive key redaction (case-insensitive matching, redacted as `***REDACTED***`)

### Output Implementations

#### ConsoleLogger
Asynchronously prints to console via `DispatchQueue(label: "com.logger.consoleLogger")`.

```swift
let consoleOutput = ConsoleLogger()
```

#### FileLogger
Appends logs to a file asynchronously via `DispatchQueue(label: "com.logger.fileLogger")`.

```swift
if let fileOutput = FileLogger(filePath: "/tmp/app.log") {
    // Use it
} else {
    // Handle failure
}
```

- Failable initializer (creates file if it doesn't exist, seeks to end)
- Fully thread-safe (`Sendable`)
- No log rotation yet (future consideration)

### LoggerBuilder

Fluent builder pattern for constructing loggers:

```swift
let logger = LoggerBuilder()
    .addOutput(ConsoleLogger())
    .addOutput(FileLogger(filePath: "/tmp/app.log")!)
    .setMinimumLogLevel(.info)
    .setRedactKeys(["token", "password"])
    .build()
```

## Usage Examples

### Basic Logging

```swift
logger.info("App started")
logger.success("User signed in", metadata: ["user": "marwan"])
logger.warning("Token expiring", metadata: ["token": "123456"])
logger.error("Login failed", metadata: ["reason": "wrong password"])
```

### With Metadata Redaction

```swift
let logger = Logger(
    outputs: [ConsoleLogger()],
    redactKeys: ["password", "token", "apiKey"]
)

logger.info("Auth attempt", metadata: ["password": "secret123"])
// Output will show: password: ***REDACTED***
```

### Filtering by Log Level

```swift
let logger = Logger(
    outputs: [ConsoleLogger()],
    minimumLogLevel: .warning  // Only .warning and .error logged
)

logger.info("This won't appear")
logger.warning("This will appear")
```

### Disabling Logging

```swift
var logger = Logger(outputs: [ConsoleLogger()])
logger.isEnabled = false  // All logging suppressed
logger.info("Won't appear")
logger.isEnabled = true   // Re-enable
```

## Testing

### Running Tests

```bash
swift test
```

Tests include:
- Log level filtering
- Metadata redaction
- Logger enable/disable
- Concurrent thread-safety (1000+ operations across 10 threads)
- File writing
- Console output
- Builder pattern

### MockLoggerOutput

For testing downstream projects:

```swift
let mockOutput = MockLoggerOutput()
let logger = Logger(outputs: [mockOutput])

logger.info("Test message")

XCTAssertEqual(mockOutput.messages.count, 1)
XCTAssertEqual(mockOutput.messages.first?.level, .info)

mockOutput.reset()  // Clear messages
```

## Thread-Safety

**The Logger is fully thread-safe and Sendable:**

- All logging calls serialize through a serial dispatch queue
- Mutable properties (`isEnabled`, `redactKeys`) are protected by NSLock
- Concurrent access from 10+ threads verified in stress tests
- Safe to pass across actor boundaries

**Implementation details:**
- `queue.sync { ... }` in `log()` ensures atomic operations
- `NSLock.withLock { }` protects property access
- `nonisolated(unsafe)` used only for lock-protected backing storage

## Development Guidelines

### When Adding Features

1. **Keep the API lean** — Add only what's necessary; prefer protocol extensions for convenience
2. **Maintain Sendable compliance** — All new types must be `Sendable` or unsafe-isolated
3. **Protect mutable state** — Use locks or queues for any shared mutation
4. **Test thread-safety** — Add concurrent access tests for new state
5. **Document thread-safety** — Specify if async, queued, or blocking

### Code Style

- Import Foundation first, then local imports
- Use `private` by default; mark public APIs explicitly
- Add docstrings to public types and methods
- Use emoji symbols for log level visual distinction
- Test coverage required for new functionality

### Common Tasks

#### Adding a New Log Output

1. Create a new `struct` or `class` conforming to `LoggerOutput` and `Sendable`
2. Implement `func log(message: String, level: LogLevel, redactedMetadata: [String: String]?)`
3. Use `DispatchQueue` for async operations to avoid blocking
4. Add tests in `Tests/LoggerTests/`

Example:
```swift
public struct SlackLogger: LoggerOutput, Sendable {
    private let webhookURL: URL
    private let queue: DispatchQueue

    public func log(message: String, level: LogLevel, redactedMetadata: [String: String]?) {
        queue.async {
            // Send to Slack asynchronously
        }
    }
}
```

#### Modifying Logger Behavior

- Changes to `log()` method: Update **Logger.swift** and add corresponding test
- Changes to state: Use NSLock if mutable, test thread-safety
- Changes to public API: Must maintain backward compatibility or major version bump

#### Testing Concurrent Access

```swift
@Test func myFeatureIsThreadSafe() {
    let output = MockLoggerOutput()
    let logger = Logger(outputs: [output])
    
    let group = DispatchGroup()
    for i in 0..<10 {
        DispatchQueue.global().async(group: group) {
            logger.info("Thread \(i)")
        }
    }
    group.wait()
    
    #expect(output.messages.count == 10)
}
```

## Current State & Future Considerations

### ✅ Completed

- Thread-safe logging with Sendable conformance
- Async output dispatching (no blocking)
- Metadata redaction with case-insensitive matching
- Log level filtering
- Builder pattern for construction
- Comprehensive test suite with concurrent stress tests
- Mock implementations for testing

### 🔄 Future Enhancements

- **FileLogger fallback** — If FileLogger init fails, automatically fall back to console
- **Log rotation** — Automatic file rotation based on size/date
- **Async/await API** — Additional async methods for structured concurrency
- **Performance profiling** — Measure logging overhead under high throughput
- **Additional outputs** — Syslog, remote logging services, analytics platforms

### Known Limitations

- No log rotation (files grow unbounded)
- ConsoleLogger uses `print()` which may interleave under extreme concurrency
- FileLogger is failable (no fallback mechanism yet)
- English-only timestamps (no localization)
- No structured/JSON logging format

## File Reference

### Key Files

- `Sources/Logger/Logger.swift` — Main thread-safe logger implementation
- `Sources/LoggerInterface/LoggerProtocol.swift` — Public logging interface
- `Sources/Logger/ConsoleLogger.swift` — Console output implementation
- `Sources/Logger/FileLogger.swift` — File output implementation
- `Sources/Logger/LoggerBuilder.swift` — Fluent builder pattern
- `Sources/LoggerInterface/LogLevel.swift` — Log level definitions
- `Tests/LoggerTests/LoggerTests.swift` — Core tests (includes thread-safety test)

### Package Configuration

- `Package.swift` — Package manifest (Swift 5.7+, iOS 13+, macOS 10.15+)
- `.swiftlint.yaml` — Code style rules
- `.codecov.yaml` — Coverage settings

## Integration with Downstream Projects

### As a Dependency

```swift
// Package.swift
.package(url: "https://github.com/..../Logger.git", from: "1.0.0")
```

### Using Mocks in Tests

```swift
import LoggerMocks

let mockLogger = MockLogger()
let mockOutput = MockLoggerOutput()

// Verify logging behavior in your tests
```

## Contact & Questions

For questions about architecture, thread-safety, or design decisions, refer to:
- Git history: `git log --oneline` for rationale behind major changes
- Comments in code for implementation details
- Test cases for usage examples

## Version History

### Current: 1.0.0

- Thread-safe Logger with Sendable conformance
- SerialDispatchQueue-based synchronization
- Lock-protected mutable state
- Concurrent stress testing (1000+ ops)
