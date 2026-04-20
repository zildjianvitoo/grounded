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
                    eyebrow: "Report",
                    title: "Session complete",
                    supportingText: "A quick summary of this session.",
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
                caption: "Breaks in this session",
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
                            PactDetailItem(label: "Why it matters", value: contract.whyItMatters)
                        ]
                    )
                }
            }

            PactActionGroup {
                PactPrimaryButton(title: "Start Again", action: onStartNewSession)
            } secondary: {
                PactSecondaryButton(title: "Edit Contract", action: onReviewContract)
            }
        }
    }

    private var summaryText: String {
        "\(session.reportFocusTimeText) focused. \(session.reportBreakTimeText) lost across \(session.breakCount) break\(session.breakCount == 1 ? "" : "s")."
    }

    private var focusMetric: some View {
        PactMetricCard(
            title: "Focused",
            value: metricValue(from: session.reportFocusTimeText),
            caption: "Time on task",
            style: .paper
        )
    }

    private var lostMetric: some View {
        PactMetricCard(
            title: "Lost",
            value: metricValue(from: session.reportBreakTimeText),
            caption: "Time away",
            style: .paper
        )
    }

    private func metricValue(from reportValue: String) -> String {
        reportValue
            .replacingOccurrences(of: " focused", with: "")
            .replacingOccurrences(of: " lost", with: "")
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
