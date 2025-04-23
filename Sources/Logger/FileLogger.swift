import LoggerInterface
import Foundation


/// Appends logs to a file asynchronously.
public final class FileLogger: LoggerOutput, Sendable {
    private let fileHandle: FileHandle
    private let queue = DispatchQueue(label: "com.logger.fileLogger")

    public init?(filePath: String) {
        let manager = FileManager.default

        if !manager.fileExists(atPath: filePath) {
            manager.createFile(atPath: filePath, contents: nil, attributes: nil)
        }

        guard let handle = FileHandle(forWritingAtPath: filePath) else { return nil }
        self.fileHandle = handle
        self.fileHandle.seekToEndOfFile()
    }

    public func log(message: String, level: LogLevel, redactedMetadata: [String: String]? = nil) {
        queue.async {
            var fullMessage = "\(Date.logFormatter.string(from: Date())): \(message)"
            if let metadata = redactedMetadata, !metadata.isEmpty {
                let formatted = metadata.map { "\($0): \($1)" }.joined(separator: ", ")
                fullMessage += " | Metadata: [\(formatted)]"
            }
            fullMessage += "\n"

            if let data = fullMessage.data(using: .utf8) {
                self.fileHandle.write(data)
            }
        }
    }

    deinit {
        try? fileHandle.close()
    }
}
