import LoggerInterface
import Foundation

/// Logs messages to configured outputs with support for filtering and redaction.
public final class Logger: LoggerProtocol {
    private let outputs: [LoggerOutput]
    private let minimumLogLevel: LogLevel
    public var isEnabled: Bool = true
    public var redactKeys: Set<String>?

    public init(outputs: [LoggerOutput], minimumLogLevel: LogLevel = .info, redactKeys: Set<String>? = nil) {
        self.outputs = outputs
        self.minimumLogLevel = minimumLogLevel
        self.redactKeys = redactKeys
    }

    public func log(_ message: String, level: LogLevel, metadata: [String: String]? = nil) {
        guard isEnabled, level >= minimumLogLevel else { return }

        let timestamp = Date.logFormatter.string(from: Date())
        let threadName = Thread.isMainThread ? "main" : (Thread.current.name ?? "background")
        let formattedMessage = "\(timestamp) [\(threadName)] \(level.symbol) [\(level.rawValue)] - \(message)"

        let redacted = metadata?.reduce(into: [String: String]()) { result, pair in
            if let keys = redactKeys,
               keys.contains(where: { $0.caseInsensitiveCompare(pair.key) == .orderedSame }) {
                result[pair.key] = "***REDACTED***"
            } else {
                result[pair.key] = pair.value
            }
        }

        outputs.forEach { $0.log(message: formattedMessage, level: level, redactedMetadata: redacted) }
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






