import LoggerInterface

/// A fluent builder for constructing logger instances.
public final class LoggerBuilder: LoggerBuilderProtocol {
    private var configuration: LoggerConfiguration

    public init() {
        configuration = LoggerConfiguration(outputs: [])
    }

    public func addOutput(_ output: any LoggerOutput) -> any LoggerBuilderProtocol {
        configuration.outputs.append(output)
        return self
    }

    public func setMinimumLogLevel(_ level: LogLevel) -> any LoggerBuilderProtocol {
        configuration.minimumLogLevel = level
        return self
    }

    public func setRedactKeys(_ keys: Set<String>) -> any LoggerBuilderProtocol {
        configuration.redactKeys = keys
        return self
    }

    public func build() -> any LoggerProtocol {
        Logger(configuration: configuration)
    }
}
