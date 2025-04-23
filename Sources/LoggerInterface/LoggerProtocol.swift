import Foundation

/// The logging interface exposed to clients.
///
/// **Example Usage:**
///
/// ```swift
/// logger.info("App started")
/// logger.success("User signed in", metadata: ["user": "marwan"])
/// logger.warning("Token expiring", metadata: ["token": "123456"])
/// logger.error("Login failed", metadata: ["reason": "wrong password", "password": "secret"])
/// ```
public protocol LoggerProtocol {
    /// Logs a message with a specified log level and optional metadata.
    ///
    /// - Parameters:
    ///   - message: The message to log.
    ///   - level: The severity level of the log.
    ///   - metadata: Optional dictionary containing additional metadata for the log.
    func log(_ message: String, level: LogLevel, metadata: [String: String]?)
    
    /// Logs an informational message with optional metadata.
    ///
    /// - Parameters:
    ///   - message: The informational message to log.
    ///   - metadata: Optional dictionary containing additional metadata for the log.
    func info(_ message: String, metadata: [String: String]?)
    
    /// Logs a success message with optional metadata.
    ///
    /// - Parameters:
    ///   - message: The success message to log.
    ///   - metadata: Optional dictionary containing additional metadata for the log.
    func success(_ message: String, metadata: [String: String]?)
    
    /// Logs a warning message with optional metadata.
    ///
    /// - Parameters:
    ///   - message: The warning message to log.
    ///   - metadata: Optional dictionary containing additional metadata for the log.
    func warning(_ message: String, metadata: [String: String]?)
    
    /// Logs an error message with optional metadata.
    ///
    /// - Parameters:
    ///   - message: The error message to log.
    ///   - metadata: Optional dictionary containing additional metadata for the log.
    func error(_ message: String, metadata: [String: String]?)
}
