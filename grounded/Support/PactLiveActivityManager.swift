import ActivityKit
import Foundation

@MainActor
enum PactLiveActivityManager {
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

        let activityContent = makeContent(for: session, contract: contract)

        if let activity = activity(for: session.id) {
            await activity.update(activityContent)
            return
        }

        for activity in Activity<PactActivityAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }

        do {
            _ = try Activity.request(
                attributes: PactActivityAttributes(
                    sessionID: session.id.uuidString,
                    taskTitle: contract.taskTitle
                ),
                content: activityContent,
                pushType: nil
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
    }

    static func endAll() async {
        for activity in Activity<PactActivityAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
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

        return ActivityContent(
            state: PactActivityAttributes.ContentState(
                statusText: session.status.displayName,
                startedAt: session.startedAt,
                targetEndAt: targetEndAt
            ),
            staleDate: targetEndAt
        )
    }
}
