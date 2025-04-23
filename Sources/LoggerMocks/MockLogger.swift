import  LoggerInterface

public final class MockLogger: LoggerProtocol {
    public private(set) var logs: [(message: String, level: LogLevel, metadata: [String: String]?)] = []

    public init() {}

    public func log(_ message: String, level: LogLevel, metadata: [String: String]?) {
        logs.append((message, level, metadata))
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
        logs.removeAll()
    }
}
