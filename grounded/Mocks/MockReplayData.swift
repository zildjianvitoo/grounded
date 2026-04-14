import Foundation

struct MockReplayData {
    let breakDurationText: String
    let reminderText: String
    let consequenceText: String

    static let sample = MockReplayData(
        breakDurationText: "You broke focus for 03:12.",
        reminderText: "You named the reason already: tomorrow's review depends on what you finish tonight.",
        consequenceText: "If you keep leaving now, the delay compounds and your team inherits the mess with you."
    )

    static let supportive = MockReplayData(
        breakDurationText: "You broke focus for 01:18.",
        reminderText: "You said this work matters because tomorrow feels lighter when tonight is handled well.",
        consequenceText: "Stay with it now, before the cost grows heavier for everyone involved."
    )

    static let savage = MockReplayData(
        breakDurationText: "You broke focus for 02:07.",
        reminderText: "You wrote the reason yourself: this only gets uglier when you leave it unfinished.",
        consequenceText: "You knew the cost when you wrote this: the team carries the delay while you look away."
    )
}
