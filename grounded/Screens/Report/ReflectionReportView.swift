import SwiftUI

struct ReflectionReportView: View {
    let contract: MockFocusContract
    let session: MockFocusSession
    let onStartNewSession: () -> Void
    let onReviewContract: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: PactSpacing.large) {
            PactCard(style: .dark) {
                PactSectionHeader(
                    eyebrow: "Reflection Report",
                    title: "Session closed",
                    supportingText: "A short reflection makes the next focus promise easier to keep.",
                    tone: .inverse
                )
            }

            ViewThatFits(in: .horizontal) {
                HStack(spacing: PactSpacing.medium) {
                    focusMetric
                    lostMetric
                }

                VStack(spacing: PactSpacing.medium) {
                    focusMetric
                    lostMetric
                }
            }

            PactMetricCard(
                title: "Breaks",
                value: "\(session.breakCount)",
                caption: "Interruptions recorded during the session",
                style: .paper
            )

            PactCard(style: .paper) {
                VStack(alignment: .leading, spacing: PactSpacing.medium) {
                    Text("Summary")
                        .font(PactTypography.label)
                        .foregroundStyle(Color.pactTextSecondary)

                    Text(summaryText)
                        .font(PactTypography.body)
                        .foregroundStyle(Color.pactTextPrimary)
                        .fixedSize(horizontal: false, vertical: true)

                    PactSectionDivider()

                    PactDetailList(
                        items: [
                            PactDetailItem(label: "Task", value: contract.taskTitle),
                            PactDetailItem(label: "Reason", value: contract.whyItMatters),
                            PactDetailItem(label: "Tone", value: contract.tone.displayName)
                        ]
                    )
                }
            }

            PactActionGroup {
                PactPrimaryButton(title: "Start New Session", action: onStartNewSession)
            } secondary: {
                PactSecondaryButton(title: "Edit Contract", action: onReviewContract)
            }
        }
    }

    private var summaryText: String {
        "You stayed with \(contract.taskTitle.lowercased()) for \(session.reportFocusTimeText). \(session.reportBreakTimeText) slipped away across \(session.breakCount) break\(session.breakCount == 1 ? "" : "s")."
    }

    private var focusMetric: some View {
        PactMetricCard(title: "Focused", value: session.reportFocusTimeText, caption: "Time spent on contract", style: .dark)
    }

    private var lostMetric: some View {
        PactMetricCard(title: "Lost", value: session.reportBreakTimeText, caption: "Time spent away from it", style: .paper)
    }
}

struct ReflectionReportView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PactScreenContainer {
                ReflectionReportView(
                    contract: .sample,
                    session: .sample,
                    onStartNewSession: {},
                    onReviewContract: {}
                )
            }
            .previewDisplayName("Typical")

            PactScreenContainer {
                ReflectionReportView(
                    contract: .sample,
                    session: .strongSession,
                    onStartNewSession: {},
                    onReviewContract: {}
                )
            }
            .previewDisplayName("Strong Session")
        }
    }
}
