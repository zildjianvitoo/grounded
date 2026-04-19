import SwiftUI

struct ActiveFocusSessionView: View {
    let contract: MockFocusContract
    let session: MockFocusSession
    let breakAlertSupportMessage: String?
    let onEndSession: () -> Void
    @ScaledMetric(relativeTo: .largeTitle) private var countdownSize = 64
    @State private var isShowingEndSessionConfirmation = false

    var body: some View {
        VStack(alignment: .leading, spacing: PactSpacing.large) {
            PactCard(style: .dark) {
                VStack(alignment: .leading, spacing: PactSpacing.small) {
                    
                    PactStatusBadge(text: session.statusLabel)
                        .padding(.bottom, 2)

                    Text(session.remainingTimeText)
                        .font(.system(size: countdownSize, weight: .bold, design: .serif))
                        .foregroundStyle(Color.pactTextInverse)
                        .monospacedDigit()
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .padding(.top, 2)

                    Text(session.taskTitle)
                        .font(PactTypography.screenTitle)
                        .foregroundStyle(Color.pactTextInverse)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            ViewThatFits(in: .horizontal) {
                HStack(spacing: PactSpacing.medium) {
                    elapsedMetric
                    breakMetric
                }

                VStack(spacing: PactSpacing.medium) {
                    elapsedMetric
                    breakMetric
                }
            }

            PactCard(style: .paper) {
                VStack(alignment: .leading, spacing: PactSpacing.medium) {
                    Text("Contract reminder")
                        .font(PactTypography.label)
                        .foregroundStyle(Color.pactTextSecondary)

                    PactDetailList(
                        items: [
                            PactDetailItem(label: "Why it matters", value: contract.whyItMatters),
                            PactDetailItem(label: "What is at stake", value: contract.consequenceText),
                            PactDetailItem(label: "Tone", value: contract.tone.displayName)
                        ]
                    )
                }
            }

            PactCard(style: .accent) {
                VStack(alignment: .leading, spacing: PactSpacing.small) {
                    Text("If focus breaks")
                        .font(PactTypography.label)
                        .foregroundStyle(Color.pactTextInverse.opacity(0.78))

                    Text("Leave the app and come back to see the contract replay that pulls you into focus again.")
                        .font(PactTypography.bodyStrong)
                        .foregroundStyle(Color.pactTextInverse)
                        .fixedSize(horizontal: false, vertical: true)

                    if let breakAlertSupportMessage {
                        PactSectionDivider(tone: .inverse)

                        Text(breakAlertSupportMessage)
                            .font(PactTypography.body)
                            .foregroundStyle(Color.pactTextInverse.opacity(0.78))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }

            PactSecondaryButton(title: "End Session", action: {
                isShowingEndSessionConfirmation = true
            })
        }
        .confirmationDialog("End this session?", isPresented: $isShowingEndSessionConfirmation, titleVisibility: .visible) {
            Button("End Session", role: .destructive, action: onEndSession)
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will stop the timer and close the current focus session.")
        }
    }

    private var elapsedMetric: some View {
        PactCompactMetricCard(
            value: session.elapsedTimeText,
            label: "Elapsed"
        )
    }

    private var breakMetric: some View {
        PactCompactMetricCard(
            value: "\(session.breakCount)",
            label: "Breaks"
        )
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
