import Foundation

struct MockFocusSession {
    let taskTitle: String
    let remainingTimeText: String
    let elapsedTimeText: String
    let statusLabel: String
    let totalFocusTimeText: String
    let totalBreakTimeText: String
    let reportFocusTimeText: String
    let reportBreakTimeText: String
    let breakCount: Int

    static let sample = MockFocusSession(
        taskTitle: "Finish the API review notes",
        remainingTimeText: "27:14",
        elapsedTimeText: "17:46",
        statusLabel: "Focus Active",
        totalFocusTimeText: "41m focused",
        totalBreakTimeText: "06m lost",
        reportFocusTimeText: "41:18 focused",
        reportBreakTimeText: "06:24 lost",
        breakCount: 2
    )

    static let pausedPreview = MockFocusSession(
        taskTitle: "Finish the API review notes",
        remainingTimeText: "24:02",
        elapsedTimeText: "20:58",
        statusLabel: "Break Active",
        totalFocusTimeText: "35m focused",
        totalBreakTimeText: "09m lost",
        reportFocusTimeText: "35:12 focused",
        reportBreakTimeText: "09:46 lost",
        breakCount: 3
    )

    static let strongSession = MockFocusSession(
        taskTitle: "Finish the API review notes",
        remainingTimeText: "00:00",
        elapsedTimeText: "45:00",
        statusLabel: "Session Complete",
        totalFocusTimeText: "43m focused",
        totalBreakTimeText: "02m lost",
        reportFocusTimeText: "43:09 focused",
        reportBreakTimeText: "02:11 lost",
        breakCount: 1
    )
}
