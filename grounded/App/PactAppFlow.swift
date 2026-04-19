import SwiftUI
import SwiftData

struct PactAppFlow: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    @Query(sort: \FocusSession.startedAt, order: .reverse) private var sessions: [FocusSession]
    @Query(sort: \FocusContract.createdAt, order: .reverse) private var contracts: [FocusContract]
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var appState = PactAppState()
    @State private var isShowingOnboarding = false
    @State private var now = Date()

    var body: some View {
        NavigationStack {
            PactScreenContainer {
                routeContent
            }
            .navigationTitle("Pact")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Pact", isPresented: errorBinding) {
                Button("OK") {
                    appState.dismissError()
                }
            } message: {
                Text(appState.errorMessage ?? "")
            }
            .fullScreenCover(isPresented: $isShowingOnboarding) {
                PactScreenContainer {
                    OnboardingView(
                        onContinue: {
                            completeOnboarding()
                        }
                    )
                }
            }
            .task {
                while !Task.isCancelled {
                    now = Date()
                    try? await Task.sleep(for: .seconds(1))
                }
            }
            .onAppear {
                appState.recoverFromPersistence(
                    latestSession: sessions.first,
                    latestContract: contracts.first,
                    scenePhase: scenePhase,
                    in: modelContext,
                    now: now
                )
                updateOnboardingPresentation()
            }
            .onChange(of: sessions.count) { _, _ in
                appState.recoverFromPersistence(
                    latestSession: sessions.first,
                    latestContract: contracts.first,
                    scenePhase: scenePhase,
                    in: modelContext,
                    now: now
                )
                updateOnboardingPresentation()
            }
            .onChange(of: now) { _, newNow in
                appState.handleClockTick(newNow, in: modelContext)
            }
            .onChange(of: scenePhase) { _, newPhase in
                appState.handleScenePhaseChange(newPhase, in: modelContext, now: now)
            }
        }
    }

    @ViewBuilder
    private var routeContent: some View {
        switch appState.route {
        case .contract:
            contractView
        case .activeSession:
            ActiveFocusSessionView(
                contract: displayContract,
                session: displaySession,
                breakAlertSupportMessage: appState.breakAlertSupportMessage,
                onEndSession: {
                    appState.endCurrentSession(in: modelContext, now: now)
                }
            )
        case .replay:
            ConsequenceReplayView(
                replay: displayReplay,
                onResumeFocus: { appState.resumeFocus() },
                onEndSession: {
                    appState.endCurrentSession(in: modelContext, now: now)
                }
            )
        case .report:
            ReflectionReportView(
                contract: displayContract,
                session: displaySession,
                onStartNewSession: { appState.startNewSession() },
                onReviewContract: { appState.reviewCurrentContract() }
            )
        }
    }

    private var contractView: some View {
        CreateFocusContractView(
            draft: appState.contractDraft,
            onStartFocus: { draft in
                appState.updateDraft(draft)
                appState.startSession(in: modelContext)
            },
            onDraftChanged: { draft in
                appState.updateDraft(draft)
            }
        )
    }

    private var persistedContract: FocusContract? {
        appState.currentContract ?? appState.currentSession?.contract ?? contracts.first
    }

    private var persistedSession: FocusSession? {
        appState.currentSession ?? sessions.first
    }

    private var displayContract: MockFocusContract {
        guard let persistedContract else {
            return .sample
        }

        return MockFocusContract(
            taskTitle: persistedContract.taskTitle,
            durationMinutes: persistedContract.durationMinutes,
            whyItMatters: persistedContract.whyItMatters,
            consequenceText: persistedContract.consequenceText,
            tone: .init(toneType: persistedContract.tone)
        )
    }

    private var displaySession: MockFocusSession {
        guard let persistedSession else {
            return .sample
        }

        let durationSeconds = (persistedSession.contract?.durationMinutes ?? displayContract.durationMinutes) * 60
        let effectiveEnd = persistedSession.endedAt ?? now
        let elapsedSeconds = max(Int(effectiveEnd.timeIntervalSince(persistedSession.startedAt)), 0)
        let breakSeconds = persistedSession.totalBreakSeconds + activeBreakElapsedSeconds
        let focusSeconds = max(elapsedSeconds - breakSeconds, 0)
        let remainingSeconds = max(durationSeconds - elapsedSeconds, 0)

        return MockFocusSession(
            taskTitle: persistedSession.contract?.taskTitle ?? displayContract.taskTitle,
            remainingTimeText: PactTimeFormatter.clockString(from: remainingSeconds),
            elapsedTimeText: PactTimeFormatter.elapsedLabel(from: elapsedSeconds),
            statusLabel: persistedSession.status.displayName,
            totalFocusTimeText: PactTimeFormatter.summaryLabel(from: focusSeconds, suffix: "focused"),
            totalBreakTimeText: PactTimeFormatter.summaryLabel(from: breakSeconds, suffix: "lost"),
            reportFocusTimeText: PactTimeFormatter.detailedSummaryLabel(from: focusSeconds, suffix: "focused"),
            reportBreakTimeText: PactTimeFormatter.detailedSummaryLabel(from: breakSeconds, suffix: "lost"),
            breakCount: persistedSession.breakCount + (appState.currentBreak == nil ? 0 : 1)
        )
    }

    private var displayReplay: MockReplayData {
        guard let persistedContract else {
            return .sample
        }

        let replayBreakSeconds = appState.latestCompletedBreak?.durationSeconds
        ?? appState.currentBreak.map { max(Int(now.timeIntervalSince($0.breakStartedAt)), 0) }
        ?? 0

        return MockReplayData(
            breakDurationText: "You broke focus for \(PactTimeFormatter.clockString(from: replayBreakSeconds)).",
            reminderText: PactInterventionText.replayReminder(for: persistedContract),
            consequenceText: PactInterventionText.replayConsequence(for: persistedContract)
        )
    }

    private var activeBreakElapsedSeconds: Int {
        guard let currentBreak = appState.currentBreak else {
            return 0
        }

        return max(Int(now.timeIntervalSince(currentBreak.breakStartedAt)), 0)
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { appState.errorMessage != nil },
            set: { isPresented in
                if !isPresented {
                    appState.dismissError()
                }
            }
        )
    }

    private func updateOnboardingPresentation() {
        isShowingOnboarding =
            !hasCompletedOnboarding &&
            sessions.isEmpty &&
            contracts.isEmpty &&
            appState.currentSession == nil
    }

    private func completeOnboarding() {
        hasCompletedOnboarding = true
        isShowingOnboarding = false
        appState.route = .contract
    }
}

struct PactAppFlow_Previews: PreviewProvider {
    static var previews: some View {
        PactAppFlow()
            .modelContainer(PactPreviewContainer.container)
    }
}

#Preview {
    PactAppFlow()
        .modelContainer(PactPreviewContainer.container)
}
