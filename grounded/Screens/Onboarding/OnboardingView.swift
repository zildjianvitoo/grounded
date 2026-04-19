import SwiftUI

struct OnboardingView: View {
    let onContinue: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: PactSpacing.large) {
            PactCard(style: .accent) {
                PactSectionHeader(
                    eyebrow: "Welcome",
                    title: "Focus is a promise, not just a timer.",
                    supportingText: "Pact asks what you need to finish, why it matters, and what gets heavier if you drift away. When you break the session, the app reflects that promise back to you.",
                    tone: .inverse
                )
            }

            benefitGrid

            PactCard(style: .paper) {
                VStack(alignment: .leading, spacing: PactSpacing.medium) {
                    Text("How it works")
                        .font(PactTypography.label)
                        .foregroundStyle(Color.pactTextSecondary)

                    PactTimelineRow(index: "1", title: "Write the contract", detail: "Task, duration, reason, and consequence.")
                    PactTimelineRow(index: "2", title: "Start focus", detail: "Keep the phone near you while the real work happens elsewhere.")
                    PactTimelineRow(index: "3", title: "Get pulled back", detail: "If you break focus, the app shows what you said was at stake.")
                }
            }

            PactPrimaryButton(title: "Start Your Contract", action: onContinue)
        }
    }

    private var benefitGrid: some View {
        VStack(spacing: PactSpacing.small) {
            PactFeatureCard(
                style: .paper,
                symbol: "laptopcomputer.and.iphone",
                title: "Built for deep work",
                detail: "Made for moments when the main task lives on your laptop."
            )

            PactFeatureCard(
                style: .muted,
                symbol: "exclamationmark.bubble",
                title: "Personal intervention",
                detail: "The app uses your own reason and consequence, so the reminder feels specific instead of generic."
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
