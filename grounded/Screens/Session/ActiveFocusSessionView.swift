import SwiftUI

struct ActiveFocusSessionView: View {
    let contract: MockFocusContract
    let session: MockFocusSession
    let breakAlertSupportMessage: String?
    let onEndSession: () -> Void
    @ScaledMetric(relativeTo: .largeTitle) private var ringDiameter = 248
    @ScaledMetric(relativeTo: .largeTitle) private var countdownSize = 58
    @State private var isShowingEndSessionConfirmation = false
    @State private var displayedRemainingSeconds: Int

    var body: some View {
        VStack(alignment: .leading, spacing: PactSpacing.large) {
            VStack(alignment: .center, spacing: PactSpacing.medium) {
                HStack {
                    PactStatusBadge(text: session.statusLabel)
                    Spacer(minLength: 0)
                }

                timerRing
                    .padding(.top, 4)

                Text(session.taskTitle)
                    .font(PactTypography.screenTitle)
                    .foregroundStyle(Color.pactTextInverse)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: ringDiameter * 0.82)
            }
            .frame(maxWidth: .infinity)
            .padding(PactSpacing.large)
            .background(heroBackground, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .stroke(heroBorder, lineWidth: 1)
            }
            .shadow(color: heroShadow, radius: 24, x: 0, y: 14)

            if session.breakCount > 0 {
                breakMetric
            }

            PactCard(style: .paper) {
                VStack(alignment: .leading, spacing: PactSpacing.medium) {
                    Text("Contract")
                        .font(PactTypography.label)
                        .foregroundStyle(Color.pactTextSecondary)

                    PactDetailList(
                        items: [
                            PactDetailItem(label: "Why it matters", value: contract.whyItMatters),
                            PactDetailItem(label: "What's at stake", value: contract.consequenceText)
                        ]
                    )
                }
            }

            if let breakAlertSupportMessage {
                PactCard(style: .muted) {
                    Text(breakAlertSupportMessage)
                        .font(PactTypography.body)
                        .foregroundStyle(Color.pactTextPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            PactDestructiveButton(title: "End Session", action: {
                isShowingEndSessionConfirmation = true
            })
        }
        .background(timerTicker)
        .alert("End this session?", isPresented: $isShowingEndSessionConfirmation) {
            Button("End Session", role: .destructive, action: onEndSession)
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This stops the timer and closes this session.")
        }
    }

    private var breakMetric: some View {
        PactCompactMetricCard(
            value: "\(session.breakCount)",
            label: "Breaks"
        )
    }

    private var timerRing: some View {
        ZStack {
            Circle()
                .stroke(timerTrackColor, lineWidth: 18)

            Circle()
                .trim(from: 0, to: progressFraction)
                .stroke(
                    Color.pactAccent,
                    style: StrokeStyle(lineWidth: 18, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .shadow(color: Color.pactAccent.opacity(0.28), radius: 14, x: 0, y: 0)

            Circle()
                .stroke(timerInnerBorderColor, lineWidth: 1)
                .padding(20)

            Text(PactTimeFormatter.clockString(from: displayedRemainingSeconds))
                .font(.system(size: countdownSize, weight: .bold, design: .serif))
                .foregroundStyle(Color.pactTextInverse)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.72)
        }
        .frame(width: ringDiameter, height: ringDiameter)
    }

    private var heroBackground: LinearGradient {
        return LinearGradient(
            colors: [
                Color(red: 0.27, green: 0.18, blue: 0.13),
                Color(red: 0.20, green: 0.14, blue: 0.10)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var heroBorder: Color {
        Color.white.opacity(0.08)
    }

    private var heroShadow: Color {
        Color.pactShadow.opacity(1.15)
    }

    private var timerTrackColor: Color {
        Color.white.opacity(0.08)
    }

    private var timerInnerBorderColor: Color {
        Color.white.opacity(0.07)
    }

    private var progressFraction: CGFloat {
        let totalSeconds = max(contract.durationMinutes * 60, 1)
        let remainingSeconds = displayedRemainingSeconds
        let elapsedSeconds = max(totalSeconds - remainingSeconds, 0)
        let fraction = CGFloat(elapsedSeconds) / CGFloat(totalSeconds)
        return min(max(fraction, 0.04), 1)
    }

    init(
        contract: MockFocusContract,
        session: MockFocusSession,
        breakAlertSupportMessage: String?,
        onEndSession: @escaping () -> Void
    ) {
        self.contract = contract
        self.session = session
        self.breakAlertSupportMessage = breakAlertSupportMessage
        self.onEndSession = onEndSession
        _displayedRemainingSeconds = State(initialValue: Self.seconds(from: session.remainingTimeText))
    }

    private static func seconds(from clockText: String) -> Int {
        let parts = clockText.split(separator: ":").compactMap { Int($0) }
        guard parts.count == 2 else {
            return 0
        }

        return max((parts[0] * 60) + parts[1], 0)
    }
}

struct ActiveFocusSessionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PactScreenContainer {
                ActiveFocusSessionView(
                    contract: .sample,
                    session: .sample,
                    breakAlertSupportMessage: nil,
                    onEndSession: {}
                )
            }
            .previewDisplayName("Active")

            PactScreenContainer {
                ActiveFocusSessionView(
                    contract: .sample,
                    session: .pausedPreview,
                    breakAlertSupportMessage: "Break alerts are off in Settings. Pact will still show the contract replay when you come back.",
                    onEndSession: {}
                )
            }
            .previewDisplayName("Break Active")
        }
    }
}

private extension ActiveFocusSessionView {
    var timerTicker: some View {
        Color.clear
            .task(id: session.remainingTimeText) {
                displayedRemainingSeconds = Self.seconds(from: session.remainingTimeText)

                while !Task.isCancelled, displayedRemainingSeconds > 0 {
                    try? await Task.sleep(for: .seconds(1))
                    guard !Task.isCancelled else {
                        return
                    }
                    displayedRemainingSeconds = max(displayedRemainingSeconds - 1, 0)
                }
            }
    }
}
