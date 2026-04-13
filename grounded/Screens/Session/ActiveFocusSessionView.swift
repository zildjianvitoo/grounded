import SwiftUI

struct ActiveFocusSessionView: View {
    let contract: MockFocusContract
    let session: MockFocusSession
    let onEndSession: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: PactSpacing.large) {
            PactCard {
                VStack(alignment: .leading, spacing: PactSpacing.medium) {
                    HStack {
                        PactSectionHeader(
                            eyebrow: "Focus Session",
                            title: session.remainingTimeText,
                            supportingText: session.taskTitle
                        )

                        Spacer(minLength: 0)
                    }

                    PactStatusBadge(text: session.statusLabel)

                    Text(session.reasonSummary)
                        .font(PactTypography.body)
                        .foregroundStyle(Color.pactTextSecondary)
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

            LiveActivityPreviewView(
                taskTitle: contract.taskTitle,
                timerText: session.remainingTimeText,
                statusText: session.statusLabel
            )

            PactCard {
                VStack(alignment: .leading, spacing: PactSpacing.medium) {
                    Text("Contract reminder")
                        .font(PactTypography.label)
                        .foregroundStyle(Color.pactTextSecondary)

                    ActiveSessionContractRow(label: "Why it matters", value: contract.whyItMatters)
                    ActiveSessionContractRow(label: "What is at stake", value: contract.consequenceText)
                    ActiveSessionContractRow(label: "Tone", value: contract.tone.displayName)
                }
            }

            PactCard {
                VStack(alignment: .leading, spacing: PactSpacing.small) {
                    Text("If focus breaks")
                        .font(PactTypography.label)
                        .foregroundStyle(Color.pactTextSecondary)

                    Text("Leave the app and come back to see the contract replay that pulls you into focus again.")
                        .font(PactTypography.body)
                        .foregroundStyle(Color.pactTextSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            PactSecondaryButton(title: "End Session", action: onEndSession)
        }
    }

    private var elapsedMetric: some View {
        PactMetricCard(
            title: "Elapsed",
            value: session.elapsedTimeText,
            caption: "Time spent honoring the current contract"
        )
    }

    private var breakMetric: some View {
        PactMetricCard(
            title: "Breaks",
            value: "\(session.breakCount)",
            caption: "Interruptions already recorded in this session"
        )
    }
}

private struct ActiveSessionContractRow: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: PactSpacing.xSmall) {
            Text(label.uppercased())
                .font(PactTypography.label)
                .foregroundStyle(Color.pactTextSecondary)

            Text(value)
                .font(PactTypography.body)
                .foregroundStyle(Color.pactTextPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct ActiveFocusSessionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PactScreenContainer {
                ActiveFocusSessionView(
                    contract: .sample,
                    session: .sample,
                    onEndSession: {}
                )
            }
            .previewDisplayName("Active")

            PactScreenContainer {
                ActiveFocusSessionView(
                    contract: .sample,
                    session: .pausedPreview,
                    onEndSession: {}
                )
            }
            .previewDisplayName("Break Active")
        }
    }
}
