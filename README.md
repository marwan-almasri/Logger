# 📦 Logger

![Swift vesion](https://img.shields.io/badge/swift-5.10-orange.svg?logo=swift)
![Xcode vesion](https://img.shields.io/badge/xcode-16.0^-blue.svg?logo=Xcode)
![Platforms](https://img.shields.io/badge/platforms-iOS|macOS-lightgray.svg?logo=apple)
[![Swift Package Tests](https://github.com/marwan-almasri/Logger/actions/workflows/test.yml/badge.svg)](https://github.com/marwan-almasri/Logger/actions/workflows/test.yml)
[![codecov](https://codecov.io/gh/marwan-almasri/Logger/graph/badge.svg?token=HKPRP9S7VT)](https://codecov.io/gh/marwan-almasri/Logger)

A lightweight, extensible Swift logging library with support for:
- ✅ Multiple log levels
- ✅ Console and file outputs
- ✅ Metadata and redaction
- ✅ Thread-safe, async logging
- ✅ Configurable via a builder pattern
- ✅ Fully testable with mocks and Swift Testing

---

## 🚀 Installation

### Using Swift Package Manager (SPM)

Add the following dependency to your `Package.swift`:

```swift
.package(url: "https://github.com/marwan-almasri/Logger.git", from: "1.0.0")
```

Then add `Logger` to your target dependencies:

```swift
.target(
    name: "MyApp",
    dependencies: [
        .product(name: "Logger", package: "Logger")
    ]
)
```

---

## 🛠 Usage

### Create a Logger

```swift
import Logger

let logger = LoggerBuilder()
    .addOutput(ConsoleLogger())
    .setMinimumLogLevel(.info)
    .setRedactKeys(["password", "token"])
    .build()
```

### Log Messages

```swift
logger.info("App started")
logger.success("User logged in", metadata: ["user": "marwan"])
logger.warning("Token expiring", metadata: ["token": "123456"])
logger.error("Login failed", metadata: ["password": "secret"])
```

### Output:
```
2025-04-23 10:00:00.123 [main] ℹ️ [INFO] - App started
2025-04-23 10:01:02.456 [main] ✅ [SUCCESS] - User logged in
Metadata: [user: marwan]
```

---

## 📂 Outputs

| Output         | Description                         |
|----------------|-------------------------------------|
| `ConsoleLogger` | Writes to the console (stdout)     |
| `FileLogger`    | Writes logs to a file (thread-safe) |

---

## 🧪 Testing

This package uses [Swift Testing](https://github.com/apple/swift-testing).

```bash
swift test
```

### Example:

```swift
@Test func logsInfoCorrectly() async throws {
    let mockOutput = MockLoggerOutput()
    let logger = Logger(outputs: [mockOutput])
    logger.info("Hello")
    #expect(mockOutput.messages.first?.level == .info)
}
```

---

## 🔐 Redaction

To avoid logging sensitive metadata:

```swift
.setRedactKeys(["token", "password"])
```

Automatically replaces those metadata values with `"***REDACTED***"`.

---

## 🧰 Advanced

### Custom Outputs

Conform to `LoggerOutput`:

```swift
public struct MyCustomLogger: LoggerOutput {
    public func log(message: String, level: LogLevel, redactedMetadata: [String: String]?) {
        // Send to analytics, crash reporting, etc.
    }
}
```

---

## 📄 License

MIT License. See [LICENSE](LICENSE) for details.

