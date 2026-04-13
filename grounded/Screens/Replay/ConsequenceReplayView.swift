import SwiftUI

struct ConsequenceReplayView: View {
    let replay: MockReplayData
    let onResumeFocus: () -> Void
    let onEndSession: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: PactSpacing.large) {
            PactCard {
                PactSectionHeader(
                    eyebrow: "Focus Interrupted",
                    title: replay.breakDurationText,
                    supportingText: "The reminder should feel like it came from your own contract, not from a nagging timer."
                )
            }

            BreakAlertPreviewView(
                title: "Back to your contract",
                bodyText: replay.reminderText
            )

            PactCard {
                VStack(alignment: .leading, spacing: PactSpacing.medium) {
                    Text("Why this matters")
                        .font(PactTypography.label)
                        .foregroundStyle(Color.pactTextSecondary)

                    Text(replay.reminderText)
                        .font(PactTypography.body)
                        .foregroundStyle(Color.pactTextPrimary)
                        .fixedSize(horizontal: false, vertical: true)

                    Divider()
                        .overlay(Color.pactBorder)

                    Text("Consequence")
                        .font(PactTypography.label)
                        .foregroundStyle(Color.pactTextSecondary)

                    Text(replay.consequenceText)
                        .font(PactTypography.screenTitle)
                        .foregroundStyle(Color.pactTextPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            PactActionGroup {
                PactPrimaryButton(title: "Resume Focus", action: onResumeFocus)
            } secondary: {
                PactSecondaryButton(title: "End Session", action: onEndSession)
            }
        }
    }
}

struct ConsequenceReplayView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PactScreenContainer {
                ConsequenceReplayView(
                    replay: .sample,
                    onResumeFocus: {},
                    onEndSession: {}
                )
            }
            .previewDisplayName("Direct")

            PactScreenContainer {
                ConsequenceReplayView(
                    replay: .supportive,
                    onResumeFocus: {},
                    onEndSession: {}
                )
            }
            .previewDisplayName("Supportive")
        }
    }
}
