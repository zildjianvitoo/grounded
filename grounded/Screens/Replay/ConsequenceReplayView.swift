import SwiftUI

struct ConsequenceReplayView: View {
    let replay: MockReplayData
    let onResumeFocus: () -> Void
    let onEndSession: () -> Void
    @State private var isShowingEndSessionConfirmation = false

    var body: some View {
        VStack(alignment: .leading, spacing: PactSpacing.large) {
            PactCard(style: .accent) {
                PactSectionHeader(
                    eyebrow: "Break",
                    title: replay.breakDurationText,
                    supportingText: nil,
                    tone: .inverse
                )
            }

            PactCard(style: .paper) {
                VStack(alignment: .leading, spacing: PactSpacing.medium) {
                    Text("Why this matters")
                        .font(PactTypography.label)
                        .foregroundStyle(Color.pactTextSecondary)

                    Text(replay.reminderText)
                        .font(PactTypography.body)
                        .foregroundStyle(Color.pactTextPrimary)
                        .fixedSize(horizontal: false, vertical: true)

                    PactSectionDivider()

                    Text("What's at stake")
                        .font(PactTypography.label)
                        .foregroundStyle(Color.pactTextSecondary)

                    Text(replay.consequenceText)
                        .font(PactTypography.display)
                        .foregroundStyle(Color.pactTextPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Spacer(minLength: PactSpacing.small)

            VStack(spacing: PactSpacing.medium) {
                PactPrimaryButton(title: "Resume Session", action: onResumeFocus)

                PactDestructiveButton(title: "End Session", action: {
                    isShowingEndSessionConfirmation = true
                })
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .alert("End this session?", isPresented: $isShowingEndSessionConfirmation) {
            Button("End Session", role: .destructive, action: onEndSession)
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This closes the session instead of returning you to it.")
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

            PactScreenContainer {
                ConsequenceReplayView(
                    replay: .savage,
                    onResumeFocus: {},
                    onEndSession: {}
                )
            }
            .previewDisplayName("Savage")
        }
    }
}
