import Testing
@testable import Logger
import LoggerMocks

struct LoggerBuilderTests {

    @Test static func loggerBuilderBuildsLogger() async throws {
        let mockOutput = MockLoggerOutput()
        let logger = LoggerBuilder()
            .addOutput(mockOutput)
            .setMinimumLogLevel(.success)
            .setRedactKeys(["secret"])
            .build()

        logger.success("Test", metadata: ["secret": "top"])

        let message = mockOutput.messages.first
        #expect(message?.level == .success)
        #expect(message?.metadata?["secret"] == "***REDACTED***")
    }

    @Test static func builderReturnsConfiguredLogger() async throws {
        let builder = MockLoggerBuilder()
        let logger = builder
            .addOutput(ConsoleLogger())
            .setMinimumLogLevel(.error)
            .setRedactKeys(["apiKey"])
            .build()

        #expect(builder.calledAddOutput)
        #expect(builder.calledSetMinimumLogLevel)
        #expect(builder.calledSetRedactKeys)
        #expect(builder.buildCalled)
    }
}
