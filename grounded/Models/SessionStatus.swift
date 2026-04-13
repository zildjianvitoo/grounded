import Foundation

enum SessionStatus: String, Codable, CaseIterable {
    case active
    case paused
    case completed
    case abandoned

    var displayName: String {
        switch self {
        case .active:
            "Focus Active"
        case .paused:
            "Break Active"
        case .completed:
            "Session Complete"
        case .abandoned:
            "Session Abandoned"
        }
    }
}
