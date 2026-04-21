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
    @State private var path: [PactRoute] = []
    @State private var now = Date()

    var body: some View {
        NavigationStack(path: $path) {
            PactScreenContainer {
                contractView
            }
            .navigationTitle(PactRoute.contract.title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: PactRoute.self) { route in
                destinationView(for: route)
            }
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
                syncNavigationPath(animated: false)
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
                syncNavigationPath(animated: false)
            }
            .onChange(of: now) { _, newNow in
                appState.handleClockTick(newNow, in: modelContext)
            }
            .onChange(of: scenePhase) { _, newPhase in
                let lifecycleNow = Date()
                now = lifecycleNow
                appState.handleScenePhaseChange(newPhase, in: modelContext, now: lifecycleNow)
            }
            .onChange(of: appState.route) { _, _ in
                syncNavigationPath()
            }
        }
    }

    private var contractView: some View {
        CreateFocusContractView(
            draft: appState.contractDraft,
            onStartFocus: { draft in
                appState.updateDraft(draft)
                appState.startSession(in: modelContext)
                syncNavigationPath()
            },
            onDraftChanged: { draft in
                appState.updateDraft(draft)
            }
        )
    }

    @ViewBuilder
    private func destinationView(for route: PactRoute) -> some View {
        switch route {
        case .contract:
            EmptyView()
        case .activeSession:
            PactScreenContainer {
                ActiveFocusSessionView(
                    contract: displayContract,
                    session: displaySession,
                    breakAlertSupportMessage: appState.breakAlertSupportMessage,
                    onEndSession: {
                        appState.endCurrentSession(in: modelContext, now: Date())
                        syncNavigationPath()
                    }
                )
            }
            .navigationTitle(route.title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        case .replay:
            PactScreenContainer {
                ConsequenceReplayView(
                    replay: displayReplay,
                    onResumeFocus: {
                        appState.resumeFocus()
                        syncNavigationPath()
                    },
                    onEndSession: {
                        appState.endCurrentSession(in: modelContext, now: Date())
                        syncNavigationPath()
                    }
                )
            }
            .navigationTitle(route.title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        case .report:
            PactScreenContainer {
                ReflectionReportView(
                    contract: displayContract,
                    session: displaySession,
                    onStartNewSession: {
                        appState.startNewSession()
                        popToContract()
                    },
                    onReviewContract: {
                        appState.reviewCurrentContract()
                        popToContract()
                    }
                )
            }
            .navigationTitle(route.title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }

    private var persistedContract: FocusContract? {
        appState.currentContract ?? appState.currentSession?.contract ?? contracts.first
    }

    private var persistedSession: FocusSession? {
        if appState.route == .report, let latestCompletedSessionID = appState.latestCompletedSessionID {
            return sessions.first(where: { $0.id == latestCompletedSessionID }) ?? appState.currentSession
        }

        return appState.currentSession ?? sessions.first
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

        let breakCount = persistedSession.breakCount + (appState.currentBreak == nil ? 0 : 1)
        let isCompleted = persistedSession.endedAt != nil || persistedSession.status == .completed
        let durationSeconds = (persistedSession.contract?.durationMinutes ?? displayContract.durationMinutes) * 60

        let elapsedSeconds: Int
        let breakSeconds: Int
        let focusSeconds: Int
        let remainingSeconds: Int

        if isCompleted {
            focusSeconds = max(persistedSession.totalFocusSeconds, 0)
            breakSeconds = max(persistedSession.totalBreakSeconds, 0)
            elapsedSeconds = focusSeconds + breakSeconds
            remainingSeconds = 0
        } else {
            let effectiveEnd = persistedSession.endedAt ?? now
            elapsedSeconds = max(Int(effectiveEnd.timeIntervalSince(persistedSession.startedAt)), 0)
            breakSeconds = persistedSession.totalBreakSeconds + activeBreakElapsedSeconds
            focusSeconds = max(elapsedSeconds - breakSeconds, 0)
            remainingSeconds = max(durationSeconds - elapsedSeconds, 0)
        }

        return MockFocusSession(
            taskTitle: persistedSession.contract?.taskTitle ?? displayContract.taskTitle,
            remainingTimeText: PactTimeFormatter.clockString(from: remainingSeconds),
            elapsedTimeText: PactTimeFormatter.elapsedLabel(from: elapsedSeconds),
            statusLabel: persistedSession.status.displayName,
            totalFocusTimeText: PactTimeFormatter.summaryLabel(from: focusSeconds, suffix: "focused"),
            totalBreakTimeText: PactTimeFormatter.summaryLabel(from: breakSeconds, suffix: "lost"),
            reportFocusTimeText: PactTimeFormatter.detailedSummaryLabel(from: focusSeconds, suffix: "focused"),
            reportBreakTimeText: PactTimeFormatter.detailedSummaryLabel(from: breakSeconds, suffix: "lost"),
            breakCount: breakCount
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
            breakDurationText: "Away for \(PactTimeFormatter.clockString(from: replayBreakSeconds)).",
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

    private func syncNavigationPath(animated: Bool = true) {
        let targetPath = navigationPath(for: appState.route)
        guard path != targetPath else {
            return
        }

        _ = animated
        path = targetPath
    }

    private func popToContract() {
        path = []
    }

    private func navigationPath(for route: PactRoute) -> [PactRoute] {
        switch route {
        case .contract:
            []
        case .activeSession:
            [.activeSession]
        case .replay:
            [.activeSession, .replay]
        case .report:
            appState.latestCompletedBreak == nil
                ? [.activeSession, .report]
                : [.activeSession, .replay, .report]
        }
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
