import LoggerInterface

public final class MockLoggerOutput: LoggerOutput {
    public private(set) var messages: [(message: String, level: LogLevel, metadata: [String: String]?)] = []

    public init() {}

    public func log(message: String, level: LogLevel, redactedMetadata: [String: String]?) {
        messages.append((message, level, redactedMetadata))
    }

    public func reset() {
        messages.removeAll()
    }
}
