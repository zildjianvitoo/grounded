import SwiftUI

struct OnboardingView: View {
    let onContinue: () -> Void
    let onUseSampleContract: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: PactSpacing.large) {
            PactCard {
                PactSectionHeader(
                    eyebrow: "Welcome",
                    title: "Focus is a promise, not just a timer.",
                    supportingText: "Pact asks what you need to finish, why it matters, and what gets heavier if you drift away. When you break the session, the app reflects that promise back to you."
                )
            }

            benefitGrid

            PactCard {
                VStack(alignment: .leading, spacing: PactSpacing.medium) {
                    Text("How it works")
                        .font(PactTypography.label)
                        .foregroundStyle(Color.pactTextSecondary)

                    PactTimelineRow(index: "1", title: "Write the contract", detail: "Task, duration, reason, and consequence.")
                    PactTimelineRow(index: "2", title: "Start focus", detail: "Keep the phone near you while the real work happens elsewhere.")
                    PactTimelineRow(index: "3", title: "Get pulled back", detail: "If you break focus, the app shows what you said was at stake.")
                }
            }

            PactActionGroup {
                PactPrimaryButton(title: "Start Your Contract", action: onContinue)
            } secondary: {
                PactSecondaryButton(title: "Use Sample Contract", action: onUseSampleContract)
            }
        }
    }

    private var benefitGrid: some View {
        VStack(spacing: PactSpacing.medium) {
            ViewThatFits(in: .horizontal) {
                HStack(spacing: PactSpacing.medium) {
                    PactFeatureCard(
                        symbol: "iphone.badge.shield.checkmark",
                        title: "Offline-first",
                        detail: "Everything important stays on-device."
                    )

                    PactFeatureCard(
                        symbol: "laptopcomputer.and.iphone",
                        title: "Built for deep work",
                        detail: "Made for moments when the main task lives on your laptop."
                    )
                }

                VStack(spacing: PactSpacing.medium) {
                    PactFeatureCard(
                        symbol: "iphone.badge.shield.checkmark",
                        title: "Offline-first",
                        detail: "Everything important stays on-device."
                    )

                    PactFeatureCard(
                        symbol: "laptopcomputer.and.iphone",
                        title: "Built for deep work",
                        detail: "Made for moments when the main task lives on your laptop."
                    )
                }
            }

            PactFeatureCard(
                symbol: "exclamationmark.bubble",
                title: "Personal intervention",
                detail: "The app uses your own reason and consequence, so the reminder feels specific instead of generic."
            )
        }
    }
}

private struct PactFeatureCard: View {
    let symbol: String
    let title: String
    let detail: String

    var body: some View {
        PactCard {
            VStack(alignment: .leading, spacing: PactSpacing.medium) {
                Image(systemName: symbol)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.pactAccent)

                Text(title)
                    .font(PactTypography.body.weight(.semibold))
                    .foregroundStyle(Color.pactTextPrimary)

                Text(detail)
                    .font(PactTypography.label)
                    .foregroundStyle(Color.pactTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
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
                .frame(width: 28, height: 28)
                .background(Color.pactAccent, in: Circle())

            VStack(alignment: .leading, spacing: PactSpacing.xSmall) {
                Text(title)
                    .font(PactTypography.body.weight(.semibold))
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
                OnboardingView(onContinue: {}, onUseSampleContract: {})
            }
            .previewDisplayName("Default")

            PactScreenContainer {
                OnboardingView(onContinue: {}, onUseSampleContract: {})
            }
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDisplayName("Landscape")
        }
    }
}
