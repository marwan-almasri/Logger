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

    public func addOutput(_: LoggerOutput) -> LoggerBuilderProtocol {
        calledAddOutput = true
        return self
    }

    public func setMinimumLogLevel(_: LogLevel) -> LoggerBuilderProtocol {
        calledSetMinimumLogLevel = true
        return self
    }

    public func setRedactKeys(_: Set<String>) -> LoggerBuilderProtocol {
        calledSetRedactKeys = true
        return self
    }

    public func build() -> LoggerProtocol {
        buildCalled = true
        return loggerToReturn
    }
}
