import Testing
import Foundation
@testable import Logger
import LoggerMocks

@Suite("Console logger tests") struct ConsoleLoggerTests {
    @Test static func testPrintsMessageAndMetadata() async throws {
        let testQueue = DispatchQueue(label: "test.console.logger")
        let logger = ConsoleLogger(queue: testQueue)

        let output = captureStandardOutput {
            logger.log(
                message: "Test message",
                level: .info,
                redactedMetadata: ["key": "value"]
            )
            testQueue.sync(flags: .barrier) {}
        }

        #expect(output.contains("Test message"))
        #expect(output.contains("key: value"))
    }
}

/// Helper function that override print during tests by temporarily redirecting the standard output (stdout) to a pipe and capturing what gets printed!
func captureStandardOutput(_ block: () -> Void) -> String {
    let pipe = Pipe()
    let readHandle = pipe.fileHandleForReading
    let writeHandle = pipe.fileHandleForWriting

    let originalStdout = dup(STDOUT_FILENO)
    dup2(writeHandle.fileDescriptor, STDOUT_FILENO)

    block()

    fflush(stdout)
    writeHandle.closeFile()

    dup2(originalStdout, STDOUT_FILENO)
    close(originalStdout)

    let data = readHandle.readDataToEndOfFile()
    readHandle.closeFile()

    return String(data: data, encoding: .utf8) ?? ""
}
