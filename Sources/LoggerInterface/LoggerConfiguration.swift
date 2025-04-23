import Foundation

/// Configuration values for building a logger.
public struct LoggerConfiguration {
    public var outputs: [LoggerOutput]
    public var minimumLogLevel: LogLevel
    public var redactKeys: Set<String>?

    public init(outputs: [LoggerOutput], minimumLogLevel: LogLevel = .info, redactKeys: Set<String>? = nil) {
        self.outputs = outputs
        self.minimumLogLevel = minimumLogLevel
        self.redactKeys = redactKeys
    }
}
