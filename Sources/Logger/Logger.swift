import Foundation
import LoggerInterface

/// Logs messages to configured outputs with support for filtering and redaction.
///
/// This class is thread-safe and can be safely accessed from multiple threads concurrently.
/// All logging operations are serialized through an internal dispatch queue to ensure
/// consistent state and message ordering.
public final class Logger: LoggerProtocol, Sendable {
    private let outputs: [LoggerOutput]
    private let minimumLogLevel: LogLevel
    private let queue: DispatchQueue
    private nonisolated let _isEnabled = NSLock()
    private nonisolated(unsafe) var _isEnabledValue: Bool = true
    private nonisolated let _redactKeysLock = NSLock()
    private nonisolated(unsafe) var _redactKeysValue: Set<String>?

    public var isEnabled: Bool {
        get {
            _isEnabled.withLock { _isEnabledValue }
        }
        set {
            _isEnabled.withLock { _isEnabledValue = newValue }
        }
    }

    public var redactKeys: Set<String>? {
        get {
            _redactKeysLock.withLock { _redactKeysValue }
        }
        set {
            _redactKeysLock.withLock { _redactKeysValue = newValue }
        }
    }

    public init(outputs: [LoggerOutput], minimumLogLevel: LogLevel = .info, redactKeys: Set<String>? = nil) {
        self.outputs = outputs
        self.minimumLogLevel = minimumLogLevel
        queue = DispatchQueue(label: "com.logger.logger")
        self.redactKeys = redactKeys
    }

    public func log(_ message: String, level: LogLevel, metadata: [String: String]? = nil) {
        queue.sync {
            let currentIsEnabled = _isEnabled.withLock { _isEnabledValue }
            let currentRedactKeys = _redactKeysLock.withLock { _redactKeysValue }

            guard currentIsEnabled, level >= minimumLogLevel else { return }

            let timestamp = Date.logFormatter.string(from: Date())
            let threadName = Thread.isMainThread ? "main" : (Thread.current.name ?? "background")
            let formattedMessage = "\(timestamp) [\(threadName)] \(level.symbol) [\(level.rawValue)] - \(message)"

            let redacted = metadata?.reduce(into: [String: String]()) { result, pair in
                if let keys = currentRedactKeys,
                   keys.contains(where: { $0.caseInsensitiveCompare(pair.key) == .orderedSame }) {
                    result[pair.key] = "***REDACTED***"
                } else {
                    result[pair.key] = pair.value
                }
            }

            outputs.forEach { $0.log(message: formattedMessage, level: level, redactedMetadata: redacted) }
        }
    }

    public func info(_ message: String, metadata: [String: String]? = nil) {
        log(message, level: .info, metadata: metadata)
    }

    public func success(_ message: String, metadata: [String: String]? = nil) {
        log(message, level: .success, metadata: metadata)
    }

    public func warning(_ message: String, metadata: [String: String]? = nil) {
        log(message, level: .warning, metadata: metadata)
    }

    public func error(_ message: String, metadata: [String: String]? = nil) {
        log(message, level: .error, metadata: metadata)
    }
}
