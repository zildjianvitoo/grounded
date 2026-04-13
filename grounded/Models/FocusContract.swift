import Foundation
import SwiftData

@Model
final class FocusContract {
    var id: UUID
    var createdAt: Date
    var taskTitle: String
    var durationMinutes: Int
    var whyItMatters: String
    var consequenceText: String
    var tone: ToneType

    @Relationship(deleteRule: .cascade, inverse: \FocusSession.contract)
    var sessions: [FocusSession]

    init(
        id: UUID = UUID(),
        createdAt: Date = .now,
        taskTitle: String,
        durationMinutes: Int,
        whyItMatters: String,
        consequenceText: String,
        tone: ToneType
    ) {
        self.id = id
        self.createdAt = createdAt
        self.taskTitle = taskTitle
        self.durationMinutes = durationMinutes
        self.whyItMatters = whyItMatters
        self.consequenceText = consequenceText
        self.tone = tone
        self.sessions = []
    }
}
