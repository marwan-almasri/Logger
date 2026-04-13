import Testing
import Foundation
@testable import Logger
import LoggerMocks

@Suite("Logger tests") struct LoggerTests {
    
    @Test static func logsAboveMinimumLevelAreRecorded() {
        let mockOutput = MockLoggerOutput()
        let logger = Logger(outputs: [mockOutput], minimumLogLevel: .warning)

        logger.info("Should not log")
        logger.warning("Should log")

        #expect(mockOutput.messages.count == 1)
        #expect(mockOutput.messages.first?.level == .warning)
    }

    @Test static func logsAreRedacted() {
        let mockOutput = MockLoggerOutput()
        let logger = Logger(outputs: [mockOutput], redactKeys: ["token"])

        logger.info("Login attempt", metadata: ["token": "123456", "user": "marwan"])

        let metadata = mockOutput.messages.first?.metadata
        #expect(metadata?["token"] == "***REDACTED***")
        #expect(metadata?["user"] == "marwan")
    }

    @Test static func loggerIsDisabled() {
        let mockOutput = MockLoggerOutput()
        let logger = Logger(outputs: [mockOutput])
        logger.isEnabled = false

        logger.error("Should not appear")
        #expect(mockOutput.messages.isEmpty)
    }

    @Test static func loggerIsThreadSafe() {
        let mockOutput = MockLoggerOutput()
        let logger = Logger(outputs: [mockOutput])
        let threadCount = 10
        let logsPerThread = 100
        let totalExpectedLogs = threadCount * logsPerThread

        // Create a group to wait for all threads to complete
        let group = DispatchGroup()
        for threadIndex in 0..<threadCount {
            DispatchQueue.global().async(group: group) {
                for logIndex in 0..<logsPerThread {
                    logger.info("Thread \(threadIndex) - Log \(logIndex)", metadata: ["thread": "\(threadIndex)"])
                }
            }
        }

        group.wait()

        // Verify all logs were recorded
        #expect(mockOutput.messages.count == totalExpectedLogs)

        // Verify metadata wasn't corrupted across concurrent calls
        let allMetadata = mockOutput.messages.compactMap { $0.metadata }
        #expect(allMetadata.count == totalExpectedLogs)

        for metadata in allMetadata {
            // Each metadata should have the thread key with a valid value
            #expect(metadata["thread"] != nil)
            if let threadValue = metadata["thread"] {
                let threadNum = Int(threadValue)
                #expect(threadNum != nil && threadNum! >= 0 && threadNum! < threadCount)
            }
        }
    }
}


