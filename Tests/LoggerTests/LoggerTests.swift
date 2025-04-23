import Testing
@testable import Logger
import LoggerMocks

struct LoggerTests {
    
    @Test static func logsAboveMinimumLevelAreRecorded() async throws {
        let mockOutput = MockLoggerOutput()
        let logger = Logger(outputs: [mockOutput], minimumLogLevel: .warning)

        logger.info("Should not log")
        logger.warning("Should log")

        #expect(mockOutput.messages.count == 1)
        #expect(mockOutput.messages.first?.level == .warning)
    }

    @Test static func logsAreRedacted() async throws {
        let mockOutput = MockLoggerOutput()
        let logger = Logger(outputs: [mockOutput], redactKeys: ["token"])

        logger.info("Login attempt", metadata: ["token": "123456", "user": "marwan"])

        let metadata = mockOutput.messages.first?.metadata
        #expect(metadata?["token"] == "***REDACTED***")
        #expect(metadata?["user"] == "marwan")
    }

    @Test static func loggerIsDisabled() async throws {
        let mockOutput = MockLoggerOutput()
        let logger = Logger(outputs: [mockOutput])
        logger.isEnabled = false

        logger.error("Should not appear")
        #expect(mockOutput.messages.isEmpty)
    }
}


