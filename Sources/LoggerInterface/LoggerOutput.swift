import Foundation

/// A protocol that defines how logs should be written by an output target.
/// Each output implementation (e.g. console, file, external service) must conform to this.
public protocol LoggerOutput {
    /// Logs a formatted message with a given log level and optionally redacted metadata.
    ///
    /// - Parameters:
    ///   - message: The fully formatted log message.
    ///   - level: The severity level of the log message.
    ///   - redactedMetadata: An optional dictionary of metadata, with sensitive values already redacted.
    func log(message: String, level: LogLevel, redactedMetadata: [String: String]?)
}
