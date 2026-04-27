import Foundation
import LoggerInterface

public final class MockLogger: LoggerProtocol {
    private let lock = NSLock()
    private var _logs: [(message: String, level: LogLevel, metadata: [String: String]?)] = []

    public var logs: [(message: String, level: LogLevel, metadata: [String: String]?)] {
        lock.withLock { _logs }
    }

    public init() {}

    public func log(_ message: String, level: LogLevel, metadata: [String: String]?) {
        lock.withLock { _logs.append((message, level, metadata)) }
    }

    public func info(_ message: String, metadata: [String: String]?) {
        log(message, level: .info, metadata: metadata)
    }

    public func success(_ message: String, metadata: [String: String]?) {
        log(message, level: .success, metadata: metadata)
    }

    public func warning(_ message: String, metadata: [String: String]?) {
        log(message, level: .warning, metadata: metadata)
    }

    public func error(_ message: String, metadata: [String: String]?) {
        log(message, level: .error, metadata: metadata)
    }

    public func reset() {
        lock.withLock { _logs.removeAll() }
    }
}
