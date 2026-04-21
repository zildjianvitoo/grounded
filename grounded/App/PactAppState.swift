import Foundation
import Observation
import SwiftUI
import SwiftData
import UIKit

@MainActor
@Observable
final class PactAppState {
    var route: PactRoute = .contract
    var contractDraft: CreateFocusContractView.Draft = .empty
    var currentContract: FocusContract?
    var currentSession: FocusSession?
    var currentBreak: FocusBreak?
    var latestCompletedBreak: FocusBreak?
    var latestCompletedSessionID: UUID?
    var dismissedCompletedSessionID: UUID?
    var errorMessage: String?
    var notificationAuthorization: BreakNotificationScheduler.AuthorizationState = .notDetermined

    func recoverFromPersistence(
        latestSession: FocusSession?,
        latestContract: FocusContract?,
        scenePhase: ScenePhase,
        in context: ModelContext,
        now: Date
    ) {
        let latestSessionIsCompleted = latestSession?.endedAt != nil || latestSession?.status == .completed
        let shouldIgnoreLatestCompletedSession =
            latestSessionIsCompleted &&
            latestSession?.id == dismissedCompletedSessionID

        currentSession = shouldIgnoreLatestCompletedSession ? nil : latestSession
        currentContract = (shouldIgnoreLatestCompletedSession ? latestSession?.contract : currentSession?.contract) ?? latestContract
        currentBreak = shouldIgnoreLatestCompletedSession ? nil : latestSession?.breaks.first(where: { $0.breakEndedAt == nil })

        if let currentContract {
            contractDraft = .init(contract: currentContract)
        }

        latestCompletedBreak = shouldIgnoreLatestCompletedSession ? nil : latestSession?.breaks
            .filter { $0.breakEndedAt != nil }
            .max(by: { $0.breakStartedAt < $1.breakStartedAt })
        latestCompletedSessionID = latestSessionIsCompleted && !shouldIgnoreLatestCompletedSession
            ? latestSession?.id
            : nil

        guard let currentSession else {
            route = .contract
            refreshNotificationAuthorization()
            syncLiveActivity(now: now)
            return
        }

        if completeSessionIfNeeded(currentSession, in: context, now: now) {
            route = .report
            refreshNotificationAuthorization()
            syncLiveActivity(now: now)
            return
        }

        if currentSession.endedAt != nil || currentSession.status == .completed {
            route = .report
            refreshNotificationAuthorization()
            syncLiveActivity(now: now)
            return
        }

        if currentBreak != nil {
            if scenePhase == .active {
                endBreakIfNeeded(in: context, now: now)
            } else {
                route = .activeSession
            }
            refreshNotificationAuthorization()
            syncLiveActivity(now: now)
            return
        }

        route = .activeSession
        refreshNotificationAuthorization()
        syncLiveActivity(now: now)
    }

    func handleClockTick(_ now: Date, in context: ModelContext) {
        guard let currentSession else {
            return
        }

        guard currentSession.endedAt == nil, currentSession.status != .completed else {
            return
        }

        guard completeSessionIfNeeded(currentSession, in: context, now: now) else {
            return
        }

        route = .report
        errorMessage = nil
        PactHaptics.endSession()
        syncLiveActivity(now: now)
    }

    func updateDraft(_ draft: CreateFocusContractView.Draft) {
        contractDraft = draft
    }

    func startSession(in context: ModelContext) {
        let draft = contractDraft
        guard draft.isReady, let durationMinutes = draft.parsedDurationMinutes else {
            PactHaptics.warning()
            errorMessage = "Complete the contract and enter a duration above 0."
            return
        }

        let contract = FocusContract(
            taskTitle: draft.taskTitle.trimmingCharacters(in: .whitespacesAndNewlines),
            durationMinutes: durationMinutes,
            whyItMatters: draft.whyItMatters.trimmingCharacters(in: .whitespacesAndNewlines),
            consequenceText: draft.consequenceText.trimmingCharacters(in: .whitespacesAndNewlines),
            tone: draft.tone.toneType
        )
        let session = FocusSession(contract: contract)

        context.insert(contract)
        context.insert(session)

        do {
            try context.save()
            currentContract = contract
            currentSession = session
            currentBreak = nil
            latestCompletedBreak = nil
            latestCompletedSessionID = nil
            dismissedCompletedSessionID = nil
            errorMessage = nil
            route = .activeSession
            PactHaptics.startFocus()
            Task {
                await PactLiveActivityManager.sync(session: session, contract: contract)
                let authorization = await BreakNotificationScheduler.requestAuthorizationIfNeeded()
                notificationAuthorization = authorization
            }
        } catch {
            PactHaptics.warning()
            errorMessage = "Couldn't start the session. Try again."
        }
    }

    func handleScenePhaseChange(_ phase: ScenePhase, in context: ModelContext, now: Date) {
        switch phase {
        case .inactive:
            break
        case .background:
            startBreakIfNeeded(in: context, now: now)
        case .active:
            refreshNotificationAuthorization()
            endBreakIfNeeded(in: context, now: now)
        @unknown default:
            break
        }
    }

    private func startBreakIfNeeded(in context: ModelContext, now: Date) {
        guard route == .activeSession, let currentSession else {
            return
        }

        guard currentSession.status == .active, currentBreak == nil, currentSession.endedAt == nil else {
            return
        }

        let focusBreak = FocusBreak(session: currentSession, breakStartedAt: now)
        currentSession.breaks.append(focusBreak)
        currentSession.status = .paused
        currentBreak = focusBreak

        do {
            try context.save()
            if let contract = currentSession.contract {
                runBackgroundCriticalTask(named: "Sync Live Activity") {
                    await PactLiveActivityManager.sync(session: currentSession, contract: contract)
                    await BreakNotificationScheduler.scheduleBreakAlert(for: contract)
                }
            }
        } catch {
            errorMessage = "Couldn't record the break."
        }
    }

    private func endBreakIfNeeded(in context: ModelContext, now: Date) {
        guard let currentSession, let currentBreak, currentSession.endedAt == nil else {
            return
        }

        currentBreak.breakEndedAt = now
        currentBreak.durationSeconds = max(Int(now.timeIntervalSince(currentBreak.breakStartedAt)), 0)
        latestCompletedBreak = currentBreak
        self.currentBreak = nil
        currentSession.breakCount = currentSession.breaks.count
        currentSession.totalBreakSeconds = currentSession.breaks.reduce(0) { $0 + $1.durationSeconds }
        currentSession.totalFocusSeconds = focusedSeconds(for: currentSession, asOf: now)
        currentSession.status = .active
        BreakNotificationScheduler.cancelPendingBreakAlert()

        do {
            try context.save()
            errorMessage = nil
            route = .replay
            PactHaptics.resumeFocus()
            if let contract = currentSession.contract {
                Task {
                    await PactLiveActivityManager.sync(session: currentSession, contract: contract)
                }
            }
        } catch {
            PactHaptics.warning()
            errorMessage = "Couldn't restore the session."
        }
    }

    func endCurrentSession(in context: ModelContext, now: Date) {
        guard let currentSession else {
            route = .report
            return
        }

        if let currentBreak {
            currentBreak.breakEndedAt = now
            currentBreak.durationSeconds = max(Int(now.timeIntervalSince(currentBreak.breakStartedAt)), 0)
            latestCompletedBreak = currentBreak
            self.currentBreak = nil
        }

        if currentSession.endedAt == nil {
            currentSession.endedAt = now
            currentSession.status = .completed
            currentSession.breakCount = currentSession.breaks.count
            currentSession.totalBreakSeconds = currentSession.breaks.reduce(0) { $0 + $1.durationSeconds }
            currentSession.totalFocusSeconds = focusedSeconds(for: currentSession, asOf: now)
        }

        latestCompletedSessionID = currentSession.id
        dismissedCompletedSessionID = nil

        BreakNotificationScheduler.cancelPendingBreakAlert()

        do {
            try context.save()
            errorMessage = nil
            route = .report
            PactHaptics.endSession()
            Task {
                await PactLiveActivityManager.end(sessionID: currentSession.id)
            }
        } catch {
            PactHaptics.warning()
            errorMessage = "Couldn't finish the session."
        }
    }

    func resumeFocus() {
        latestCompletedBreak = nil
        route = .activeSession
    }

    func reviewCurrentContract() {
        dismissedCompletedSessionID = latestCompletedSessionID ?? currentSession?.id

        if let currentContract {
            contractDraft = .init(contract: currentContract)
        }

        currentSession = nil
        currentBreak = nil
        latestCompletedBreak = nil
        latestCompletedSessionID = nil
        route = .contract
    }

    func startNewSession() {
        dismissedCompletedSessionID = latestCompletedSessionID ?? currentSession?.id
        currentSession = nil
        currentBreak = nil
        latestCompletedBreak = nil
        latestCompletedSessionID = nil

        if let currentContract {
            contractDraft = .init(contract: currentContract)
        }

        route = .contract
    }

    func dismissError() {
        errorMessage = nil
    }

    var breakAlertSupportMessage: String? {
        guard route == .activeSession, notificationAuthorization == .denied else {
            return nil
        }

        return "Break alerts are off. Pact will show the contract when you return."
    }

    private func focusedSeconds(for session: FocusSession, asOf now: Date) -> Int {
        let sessionEnd = session.endedAt ?? now
        let elapsed = max(Int(sessionEnd.timeIntervalSince(session.startedAt)), 0)
        return max(elapsed - session.totalBreakSeconds, 0)
    }

    @discardableResult
    private func completeSessionIfNeeded(_ session: FocusSession, in context: ModelContext, now: Date) -> Bool {
        guard session.endedAt == nil, session.status != .completed else {
            return false
        }

        guard let targetEnd = targetEndDate(for: session), now >= targetEnd else {
            return false
        }

        if let activeBreak = currentBreak {
            let breakEnd = min(now, targetEnd)
            activeBreak.breakEndedAt = breakEnd
            activeBreak.durationSeconds = max(Int(breakEnd.timeIntervalSince(activeBreak.breakStartedAt)), 0)
            latestCompletedBreak = activeBreak
            currentBreak = nil
        }

        session.endedAt = targetEnd
        session.status = .completed
        session.breakCount = session.breaks.count
        session.totalBreakSeconds = session.breaks.reduce(0) { $0 + $1.durationSeconds }
        session.totalFocusSeconds = focusedSeconds(for: session, asOf: targetEnd)
        latestCompletedSessionID = session.id
        dismissedCompletedSessionID = nil
        BreakNotificationScheduler.cancelPendingBreakAlert()

        do {
            try context.save()
            Task {
                await PactLiveActivityManager.end(sessionID: session.id)
            }
            return true
        } catch {
            PactHaptics.warning()
            errorMessage = "Couldn't close the session automatically."
            return false
        }
    }

    private func targetEndDate(for session: FocusSession) -> Date? {
        guard let durationMinutes = session.contract?.durationMinutes else {
            return nil
        }

        return session.startedAt.addingTimeInterval(TimeInterval(durationMinutes * 60))
    }

    private func refreshNotificationAuthorization() {
        Task {
            notificationAuthorization = await BreakNotificationScheduler.currentAuthorizationState()
        }
    }

    private func syncLiveActivity(now: Date) {
        Task {
            await PactLiveActivityManager.sync(
                session: currentSession,
                contract: currentContract ?? currentSession?.contract
            )
        }
    }

    private func runBackgroundCriticalTask(
        named taskName: String,
        operation: @escaping () async -> Void
    ) {
        var taskID: UIBackgroundTaskIdentifier = .invalid
        taskID = UIApplication.shared.beginBackgroundTask(withName: taskName) {
            if taskID != .invalid {
                UIApplication.shared.endBackgroundTask(taskID)
                taskID = .invalid
            }
        }

        Task {
            await operation()
            if taskID != .invalid {
                UIApplication.shared.endBackgroundTask(taskID)
                taskID = .invalid
            }
        }
    }
}
