import LoggerInterface

public final class MockLoggerBuilder: LoggerBuilderProtocol {
    public private(set) var calledAddOutput = false
    public private(set) var calledSetMinimumLogLevel = false
    public private(set) var calledSetRedactKeys = false
    public private(set) var buildCalled = false

    public var loggerToReturn: LoggerProtocol

    public init(loggerToReturn: LoggerProtocol = MockLogger()) {
        self.loggerToReturn = loggerToReturn
    }

    public func addOutput(_: any LoggerOutput) -> any LoggerBuilderProtocol {
        calledAddOutput = true
        return self
    }

    public func setMinimumLogLevel(_: LogLevel) -> any LoggerBuilderProtocol {
        calledSetMinimumLogLevel = true
        return self
    }

    public func setRedactKeys(_: Set<String>) -> any LoggerBuilderProtocol {
        calledSetRedactKeys = true
        return self
    }

    public func build() -> any LoggerProtocol {
        buildCalled = true
        return loggerToReturn
    }
}
