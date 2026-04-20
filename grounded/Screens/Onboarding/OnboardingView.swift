import SwiftUI

struct OnboardingView: View {
    let onContinue: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: PactSpacing.medium) {
            PactCard(style: .accent) {
                PactSectionHeader(
                    eyebrow: "Welcome",
                    title: "Focus with a contract.",
                    supportingText: "Write what you're doing, why it matters, and what happens if you drift.",
                    tone: .inverse
                )
            }

            benefitGrid

            PactCard(style: .paper) {
                VStack(alignment: .leading, spacing: PactSpacing.medium) {
                    Text("How it works")
                        .font(PactTypography.label)
                        .foregroundStyle(Color.pactTextSecondary)

                    PactTimelineRow(index: "1", title: "Write it down", detail: "Task, time, reason, and stakes.")
                    PactTimelineRow(index: "2", title: "Start a session", detail: "Keep focus while the work happens elsewhere.")
                    PactTimelineRow(index: "3", title: "Come back to it", detail: "If you leave, Pact shows your contract again.")
                }
            }

            Spacer(minLength: PactSpacing.small)

            PactPrimaryButton(title: "Create Contract", action: onContinue)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    private var benefitGrid: some View {
        VStack(spacing: PactSpacing.small) {
            PactFeatureCard(
                style: .muted,
                symbol: "exclamationmark.bubble",
                title: "Your own reminder",
                detail: "If you drift, Pact brings back the words you wrote."
            )
        }
    }
}

private struct PactFeatureCard: View {
    let style: PactCardStyle
    let symbol: String
    let title: String
    let detail: String

    var body: some View {
        PactCard(style: style, contentPadding: 18) {
            VStack(alignment: .leading, spacing: PactSpacing.small) {
                Image(systemName: symbol)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(symbolColor)

                Text(title)
                    .font(PactTypography.bodyStrong)
                    .foregroundStyle(titleColor)

                Text(detail)
                    .font(PactTypography.label)
                    .foregroundStyle(detailColor)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var symbolColor: Color {
        style == .dark ? Color.pactAccentSoft : Color.pactAccent
    }

    private var titleColor: Color {
        style == .dark ? Color.pactTextInverse : Color.pactTextPrimary
    }

    private var detailColor: Color {
        style == .dark ? Color.pactTextInverse.opacity(0.74) : Color.pactTextSecondary
    }
}

private struct PactTimelineRow: View {
    let index: String
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: PactSpacing.medium) {
            Text(index)
                .font(PactTypography.caption)
                .foregroundStyle(Color.white)
                .frame(width: 32, height: 32)
                .background(
                    LinearGradient(
                        colors: [Color.pactAccentSoft, Color.pactAccent],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    in: Circle()
                )

            VStack(alignment: .leading, spacing: PactSpacing.xSmall) {
                Text(title)
                    .font(PactTypography.bodyStrong)
                    .foregroundStyle(Color.pactTextPrimary)

                Text(detail)
                    .font(PactTypography.label)
                    .foregroundStyle(Color.pactTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PactScreenContainer {
                OnboardingView(onContinue: {})
            }
            .previewDisplayName("Default")

            PactScreenContainer {
                OnboardingView(onContinue: {})
            }
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDisplayName("Landscape")
        }
    }
}
