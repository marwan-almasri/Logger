import Foundation

/// A protocol that defines a configurable interface for building `LoggerProtocol` instances.
/// Useful for dependency injection and mocking logger construction in tests.
///
/// **Example Usage:**
/// ```swift
/// let logger = LoggerBuilder()
///     .addOutput(ConsoleLogger())
///     .addOutput(FileLogger(filePath: "/tmp/app.log")!)
///     .setMinimumLogLevel(.info)
///     .setRedactKeys(["token", "password"])
///     .build()
/// ```
public protocol LoggerBuilderProtocol {
    /// Adds a log output target to the logger.
    ///
    /// - Parameter output: A conforming `LoggerOutput` instance.
    /// - Returns: The builder instance for chaining.
    func addOutput(_ output: LoggerOutput) -> LoggerBuilderProtocol

    /// Sets the minimum log level that will be recorded.
    ///
    /// - Parameter level: The lowest `LogLevel` that will be logged.
    /// - Returns: The builder instance for chaining.
    func setMinimumLogLevel(_ level: LogLevel) -> LoggerBuilderProtocol

    /// Sets metadata keys that should be redacted in the output logs.
    ///
    /// - Parameter keys: A set of sensitive metadata keys to redact (e.g., "password", "token").
    /// - Returns: The builder instance for chaining.
    func setRedactKeys(_ keys: Set<String>) -> LoggerBuilderProtocol

    /// Builds and returns a configured logger instance.
    ///
    /// - Returns: A fully configured `LoggerProtocol` instance.
    func build() -> LoggerProtocol
}
