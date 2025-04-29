import Testing
import Foundation
@testable import Logger
import LoggerInterface
import LoggerMocks

@Suite("File logger tests") struct FileLoggerTests {

    @Test static func testLogIsWrittenToFile() async throws {
        let testQueue = DispatchQueue(label: "test.file.logger")
        let tempFileURL = FileManager.default.temporaryDirectory.appendingPathComponent("log-\(UUID().uuidString).txt")
        let filePath = tempFileURL.path

        // Create logger
        guard let logger = FileLogger(filePath: filePath, queue: testQueue) else {
            Issue.record("Could not create FileLogger with path: \(filePath)")
            return
        }

        // Log a message
        logger.log(
            message: "Test message from FileLogger",
            level: .info,
            redactedMetadata: ["key": "value"]
        )

        // Ensure async write is completed
        testQueue.sync(flags: .barrier) {}

        // Read the log file
        let contents = try String(contentsOf: tempFileURL, encoding: .utf8)

        // Assert log message and metadata are present
        #expect(contents.contains("Test message from FileLogger"))
        #expect(contents.contains("key: value"))

        // Clean up
        try? FileManager.default.removeItem(at: tempFileURL)
    }
}
