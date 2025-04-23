import LoggerInterface

/// A fluent builder for constructing logger instances.
public final class LoggerBuilder: LoggerBuilderProtocol {
    
    private var outputs: [LoggerOutput] = []
    private var minimumLogLevel: LogLevel = .info
    private var redactKeys: Set<String>?

    public init() {}
    
    public func addOutput(_ output: any LoggerOutput) -> any LoggerBuilderProtocol {
        outputs.append(output)
        return self
    }
    
    public func setMinimumLogLevel(_ level: LogLevel) -> any LoggerBuilderProtocol {
        minimumLogLevel = level
        return self
    }
    
    public func setRedactKeys(_ keys: Set<String>) -> any LoggerBuilderProtocol {
        redactKeys = keys
        return self
    }
    
    public func build() -> any LoggerProtocol {
        Logger(outputs: outputs, minimumLogLevel: minimumLogLevel, redactKeys: redactKeys)
    }
}
