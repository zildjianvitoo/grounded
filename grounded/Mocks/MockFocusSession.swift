import Foundation

struct MockFocusSession {
    let taskTitle: String
    let reasonSummary: String
    let remainingTimeText: String
    let elapsedTimeText: String
    let statusLabel: String
    let totalFocusTimeText: String
    let totalBreakTimeText: String
    let breakCount: Int

    static let sample = MockFocusSession(
        taskTitle: "Finish the API review notes",
        reasonSummary: "This keeps tomorrow's review sharp and prevents extra churn for the team.",
        remainingTimeText: "27:14",
        elapsedTimeText: "17:46 elapsed",
        statusLabel: "Focus Active",
        totalFocusTimeText: "41m focused",
        totalBreakTimeText: "06m lost",
        breakCount: 2
    )

    static let pausedPreview = MockFocusSession(
        taskTitle: "Finish the API review notes",
        reasonSummary: "You were in a good stretch before the interruption pulled your attention away.",
        remainingTimeText: "24:02",
        elapsedTimeText: "20:58 elapsed",
        statusLabel: "Break Active",
        totalFocusTimeText: "35m focused",
        totalBreakTimeText: "09m lost",
        breakCount: 3
    )

    static let strongSession = MockFocusSession(
        taskTitle: "Finish the API review notes",
        reasonSummary: "Most of the session stayed anchored to the task.",
        remainingTimeText: "00:00",
        elapsedTimeText: "45:00 elapsed",
        statusLabel: "Session Complete",
        totalFocusTimeText: "43m focused",
        totalBreakTimeText: "02m lost",
        breakCount: 1
    )
}
