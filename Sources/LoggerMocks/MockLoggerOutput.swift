import Foundation
import LoggerInterface

public final class MockLoggerOutput: LoggerOutput {
    private nonisolated let lock = NSLock()
    private nonisolated(unsafe) var _messages: [(message: String, level: LogLevel, metadata: [String: String]?)] = []

    public var messages: [(message: String, level: LogLevel, metadata: [String: String]?)] {
        lock.withLock { _messages }
    }

    public init() {}

    public func log(message: String, level: LogLevel, redactedMetadata: [String: String]?) {
        lock.withLock {
            _messages.append((message, level, redactedMetadata))
        }
    }

    public func reset() {
        lock.withLock {
            _messages.removeAll()
        }
    }
}
