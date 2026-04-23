import ActivityKit
import Foundation

@MainActor
enum PactLiveActivityManager {
    private static var lastSyncedSessionID: String?
    private static var lastSyncedTaskTitle: String?
    private static var lastSyncedState: PactActivityAttributes.ContentState?

    static func sync(session: FocusSession?, contract: FocusContract?) async {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            return
        }

        guard
            let session,
            let contract,
            session.endedAt == nil
        else {
            await endAll()
            return
        }

        let attributes = PactActivityAttributes(
            sessionID: session.id.uuidString,
            taskTitle: contract.taskTitle
        )
        let activityContent = makeContent(for: session, contract: contract)

        if let activity = activity(for: session.id) {
            guard shouldUpdate(
                sessionID: attributes.sessionID,
                taskTitle: attributes.taskTitle,
                state: activityContent.state
            ) else {
                return
            }

            await activity.update(activityContent)
            rememberSync(
                sessionID: attributes.sessionID,
                taskTitle: attributes.taskTitle,
                state: activityContent.state
            )
            return
        }

        for activity in Activity<PactActivityAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }

        do {
            _ = try Activity.request(
                attributes: attributes,
                content: activityContent,
                pushType: nil
            )
            rememberSync(
                sessionID: attributes.sessionID,
                taskTitle: attributes.taskTitle,
                state: activityContent.state
            )
        } catch {
            debugPrint("Live Activity request failed:", error.localizedDescription)
        }
    }

    static func end(sessionID: UUID?) async {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            return
        }

        guard let sessionID else {
            await endAll()
            return
        }

        if let activity = activity(for: sessionID) {
            await activity.end(nil, dismissalPolicy: .immediate)
        }

        resetSyncCache(for: sessionID.uuidString)
    }

    static func endAll() async {
        for activity in Activity<PactActivityAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }

        resetSyncCache()
    }

    private static func activity(for sessionID: UUID) -> Activity<PactActivityAttributes>? {
        Activity<PactActivityAttributes>.activities.first {
            $0.attributes.sessionID == sessionID.uuidString
        }
    }

    private static func makeContent(
        for session: FocusSession,
        contract: FocusContract
    ) -> ActivityContent<PactActivityAttributes.ContentState> {
        let targetEndAt = session.startedAt.addingTimeInterval(TimeInterval(contract.durationMinutes * 60))
        let activeBreakStartedAt = session.breaks.last(where: { $0.breakEndedAt == nil })?.breakStartedAt

        return ActivityContent(
            state: PactActivityAttributes.ContentState(
                statusText: session.status.displayName,
                startedAt: session.startedAt,
                targetEndAt: targetEndAt,
                breakStartedAt: activeBreakStartedAt
            ),
            staleDate: targetEndAt
        )
    }

    private static func shouldUpdate(
        sessionID: String,
        taskTitle: String,
        state: PactActivityAttributes.ContentState
    ) -> Bool {
        lastSyncedSessionID != sessionID ||
        lastSyncedTaskTitle != taskTitle ||
        lastSyncedState != state
    }

    private static func rememberSync(
        sessionID: String,
        taskTitle: String,
        state: PactActivityAttributes.ContentState
    ) {
        lastSyncedSessionID = sessionID
        lastSyncedTaskTitle = taskTitle
        lastSyncedState = state
    }

    private static func resetSyncCache(for sessionID: String? = nil) {
        guard let sessionID else {
            lastSyncedSessionID = nil
            lastSyncedTaskTitle = nil
            lastSyncedState = nil
            return
        }

        guard lastSyncedSessionID == sessionID else {
            return
        }

        lastSyncedSessionID = nil
        lastSyncedTaskTitle = nil
        lastSyncedState = nil
    }
}
