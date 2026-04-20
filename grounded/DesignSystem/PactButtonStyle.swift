import SwiftUI

struct PactPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(PactTypography.bodyStrong)
            .tracking(0.2)
            .foregroundStyle(Color.pactTextInverse)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, PactSpacing.large)
            .padding(.vertical, 16)
            .background(
                Capsule()
                    .fill(Color.pactAccent.opacity(configuration.isPressed ? 0.88 : 1))
            )
            .overlay {
                Capsule()
                    .stroke(Color.pactAccentSoft.opacity(configuration.isPressed ? 0.28 : 0.22), lineWidth: 1)
            }
            .shadow(color: Color.pactShadow.opacity(0.75), radius: 16, x: 0, y: 10)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

struct PactSecondaryButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var colorScheme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(PactTypography.bodyStrong)
            .tracking(0.15)
            .foregroundStyle(secondaryTextColor(isPressed: configuration.isPressed))
            .frame(maxWidth: .infinity)
            .padding(.horizontal, PactSpacing.large)
            .padding(.vertical, 16)
            .background(
                Capsule()
                    .fill(secondaryFill(isPressed: configuration.isPressed))
            )
            .overlay {
                Capsule()
                    .stroke(secondaryBorder(isPressed: configuration.isPressed), lineWidth: 1.5)
            }
            .shadow(color: secondaryShadow.opacity(configuration.isPressed ? 0.08 : 0.14), radius: 12, x: 0, y: 8)
            .opacity(configuration.isPressed ? 0.85 : 1)
            .scaleEffect(configuration.isPressed ? 0.99 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }

    private func secondaryFill(isPressed: Bool) -> Color {
        if colorScheme == .dark {
            return Color.pactElevatedSurface.opacity(isPressed ? 0.96 : 1)
        }

        return Color.pactSurface.opacity(isPressed ? 0.96 : 1)
    }

    private func secondaryBorder(isPressed: Bool) -> Color {
        if colorScheme == .dark {
            return Color.pactAccentSoft.opacity(isPressed ? 0.92 : 0.82)
        }

        return Color.pactAccent.opacity(isPressed ? 0.72 : 0.62)
    }

    private func secondaryTextColor(isPressed: Bool) -> Color {
        let base = colorScheme == .dark ? Color.pactTextInverse : Color.pactAccent
        return base.opacity(isPressed ? 0.9 : 1)
    }

    private var secondaryShadow: Color {
        colorScheme == .dark ? Color.black : Color.pactShadow
    }
}

struct PactDestructiveButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var colorScheme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(PactTypography.bodyStrong)
            .tracking(0.15)
            .foregroundStyle(destructiveTextColor(isPressed: configuration.isPressed))
            .frame(maxWidth: .infinity)
            .padding(.horizontal, PactSpacing.large)
            .padding(.vertical, 16)
            .background(
                Capsule()
                    .fill(destructiveFill(isPressed: configuration.isPressed))
            )
            .overlay {
                Capsule()
                    .stroke(destructiveBorder(isPressed: configuration.isPressed), lineWidth: 1.5)
            }
            .shadow(color: destructiveShadow.opacity(configuration.isPressed ? 0.14 : 0.2), radius: 12, x: 0, y: 8)
            .opacity(configuration.isPressed ? 0.92 : 1)
            .scaleEffect(configuration.isPressed ? 0.99 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }

    private func destructiveFill(isPressed: Bool) -> Color {
        if colorScheme == .dark {
            return Color.pactDarkSurfaceRaised.opacity(isPressed ? 0.96 : 1)
        }

        return Color.pactSurface.opacity(isPressed ? 0.94 : 1)
    }

    private func destructiveBorder(isPressed: Bool) -> Color {
        let base = colorScheme == .dark ? Color.pactAccent : Color.pactAccent.opacity(0.78)
        return base.opacity(isPressed ? 0.92 : 1)
    }

    private func destructiveTextColor(isPressed: Bool) -> Color {
        let base = colorScheme == .dark ? Color.pactAccentSoft : Color.pactAccent
        return base.opacity(isPressed ? 0.9 : 1)
    }

    private var destructiveShadow: Color {
        colorScheme == .dark ? Color.black : Color.pactAccent
    }
}
