import Foundation

/// Represents the severity level of a log message.
/// Conforms to `Comparable` to support filtering.
public enum LogLevel: String, Comparable, Sendable {
    case info = "INFO"
    case success = "SUCCESS"
    case warning = "WARNING"
    case error = "ERROR"

    /// Emoji symbol representing the log level.
    public var symbol: String {
        switch self {
        case .info: return "ℹ️"
        case .success: return "✅"
        case .warning: return "⚠️"
        case .error: return "⛔️"
        }
    }

    /// Color indicator for UI or formatting.
    public var status: String {
        switch self {
        case .info: return "🔵"
        case .success: return "🟢"
        case .warning: return "🟡"
        case .error: return "🔴"
        }
    }

    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        lhs.order < rhs.order
    }

    private var order: Int {
        switch self {
        case .info: return 0
        case .success: return 1
        case .warning: return 2
        case .error: return 3
        }
    }
}
