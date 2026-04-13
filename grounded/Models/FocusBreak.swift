import Foundation
import SwiftData

@Model
final class FocusBreak {
    var id: UUID
    var breakStartedAt: Date
    var breakEndedAt: Date?
    var durationSeconds: Int

    var session: FocusSession?

    init(
        id: UUID = UUID(),
        session: FocusSession,
        breakStartedAt: Date = .now,
        breakEndedAt: Date? = nil,
        durationSeconds: Int = 0
    ) {
        self.id = id
        self.session = session
        self.breakStartedAt = breakStartedAt
        self.breakEndedAt = breakEndedAt
        self.durationSeconds = durationSeconds
    }
}
