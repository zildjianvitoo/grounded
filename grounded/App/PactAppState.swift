import Foundation
import Observation
import SwiftUI
import SwiftData

@MainActor
@Observable
final class PactAppState {
    var route: PactRoute = .onboarding
    var contractDraft: CreateFocusContractView.Draft = .filledSample
    var currentContract: FocusContract?
    var currentSession: FocusSession?
    var currentBreak: FocusBreak?
    var latestCompletedBreak: FocusBreak?
    var errorMessage: String?

    func recoverFromPersistence(
        latestSession: FocusSession?,
        latestContract: FocusContract?,
        scenePhase: ScenePhase,
        in context: ModelContext,
        now: Date
    ) {
        currentSession = latestSession
        currentContract = latestSession?.contract ?? latestContract
        currentBreak = latestSession?.breaks.first(where: { $0.breakEndedAt == nil })

        if let currentContract {
            contractDraft = .init(contract: currentContract)
        }

        latestCompletedBreak = latestSession?.breaks
            .filter { $0.breakEndedAt != nil }
            .max(by: { $0.breakStartedAt < $1.breakStartedAt })

        guard let currentSession else {
            route = currentContract == nil ? .onboarding : .contract
            syncLiveActivity(now: now)
            return
        }

        if currentSession.endedAt != nil || currentSession.status == .completed {
            route = .report
            syncLiveActivity(now: now)
            return
        }

        if currentBreak != nil {
            if scenePhase == .active {
                endBreakIfNeeded(in: context, now: now)
            } else {
                route = .activeSession
            }
            syncLiveActivity(now: now)
            return
        }

        route = .activeSession
        syncLiveActivity(now: now)
    }

    func updateDraft(_ draft: CreateFocusContractView.Draft) {
        contractDraft = draft
    }

    func loadSampleContract() {
        contractDraft = .filledSample
    }

    func startSession(in context: ModelContext) {
        let draft = contractDraft
        guard draft.isReady, let durationMinutes = Int(draft.durationMinutes) else {
            PactHaptics.warning()
            errorMessage = "Please complete the contract before starting focus."
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
            errorMessage = nil
            route = .activeSession
            PactHaptics.startFocus()
            Task {
                await PactLiveActivityManager.sync(session: session, contract: contract)
                await BreakNotificationScheduler.requestAuthorizationIfNeeded()
            }
        } catch {
            PactHaptics.warning()
            errorMessage = "Couldn't start the focus session. Please try again."
        }
    }

    func handleScenePhaseChange(_ phase: ScenePhase, in context: ModelContext, now: Date) {
        switch phase {
        case .inactive, .background:
            startBreakIfNeeded(in: context, now: now)
        case .active:
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
                Task {
                    await PactLiveActivityManager.sync(session: currentSession, contract: contract)
                    await BreakNotificationScheduler.scheduleBreakAlert(for: contract)
                }
            }
        } catch {
            errorMessage = "Couldn't record the focus break."
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
            errorMessage = "Couldn't restore the session after the break."
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
            errorMessage = "Couldn't finalize the session summary."
        }
    }

    func resumeFocus() {
        latestCompletedBreak = nil
        route = .activeSession
    }

    func reviewCurrentContract() {
        if let currentContract {
            contractDraft = .init(contract: currentContract)
        }

        route = .contract
    }

    func startNewSession() {
        currentSession = nil
        currentBreak = nil
        latestCompletedBreak = nil

        if let currentContract {
            contractDraft = .init(contract: currentContract)
        }

        route = .contract
    }

    func dismissError() {
        errorMessage = nil
    }

    private func focusedSeconds(for session: FocusSession, asOf now: Date) -> Int {
        let sessionEnd = session.endedAt ?? now
        let elapsed = max(Int(sessionEnd.timeIntervalSince(session.startedAt)), 0)
        return max(elapsed - session.totalBreakSeconds, 0)
    }

    private func syncLiveActivity(now: Date) {
        Task {
            await PactLiveActivityManager.sync(
                session: currentSession,
                contract: currentContract ?? currentSession?.contract
            )
        }
    }
}
