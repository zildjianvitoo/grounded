import Foundation
import SwiftData

@Model
final class FocusSession {
    var id: UUID
    var startedAt: Date
    var endedAt: Date?
    var status: SessionStatus
    var totalFocusSeconds: Int
    var totalBreakSeconds: Int
    var breakCount: Int

    var contract: FocusContract?

    @Relationship(deleteRule: .cascade, inverse: \FocusBreak.session)
    var breaks: [FocusBreak]

    init(
        id: UUID = UUID(),
        contract: FocusContract,
        startedAt: Date = .now,
        endedAt: Date? = nil,
        status: SessionStatus = .active,
        totalFocusSeconds: Int = 0,
        totalBreakSeconds: Int = 0,
        breakCount: Int = 0
    ) {
        self.id = id
        self.contract = contract
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.status = status
        self.totalFocusSeconds = totalFocusSeconds
        self.totalBreakSeconds = totalBreakSeconds
        self.breakCount = breakCount
        self.breaks = []
    }
}
