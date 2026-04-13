import Foundation

enum PactTimeFormatter {
    static func clockString(from totalSeconds: Int) -> String {
        let safeSeconds = max(totalSeconds, 0)
        let minutes = safeSeconds / 60
        let seconds = safeSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    static func elapsedLabel(from totalSeconds: Int) -> String {
        "\(clockString(from: totalSeconds)) elapsed"
    }

    static func summaryLabel(from totalSeconds: Int, suffix: String) -> String {
        let minutes = max(totalSeconds, 0) / 60
        return "\(minutes)m \(suffix)"
    }
}
