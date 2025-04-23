import LoggerInterface
import Foundation

/// Outputs logs to the console asynchronously.
public struct ConsoleLogger: LoggerOutput {
    private let queue = DispatchQueue(label: "com.logger.consoleLogger")

    public init() {}

    public func log(message: String, level: LogLevel, redactedMetadata: [String: String]? = nil) {
        queue.async {
            print(message)
            if let metadata = redactedMetadata, !metadata.isEmpty {
                let formatted = metadata.map { "\($0): \($1)" }.joined(separator: ", ")
                print("Metadata: [\(formatted)]")
            }
        }
    }
}
