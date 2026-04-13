import Foundation

struct MockReplayData {
    let breakDurationText: String
    let reminderText: String
    let consequenceText: String

    static let sample = MockReplayData(
        breakDurationText: "You broke focus for 03:12.",
        reminderText: "You said this task matters because tomorrow's review depends on what you finish tonight.",
        consequenceText: "If you keep leaving now, the delay compounds and your team inherits the mess with you."
    )

    static let supportive = MockReplayData(
        breakDurationText: "You broke focus for 01:18.",
        reminderText: "You said this work matters because tomorrow feels lighter when tonight is handled well.",
        consequenceText: "Come back gently, but come back now before the cost grows."
    )
}
