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
            .foregroundStyle(Color.pactTextPrimary)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, PactSpacing.large)
            .padding(.vertical, 16)
            .background(
                Capsule()
                    .fill(secondaryFill(isPressed: configuration.isPressed))
            )
            .overlay {
                Capsule()
                    .stroke(secondaryBorder(isPressed: configuration.isPressed), lineWidth: 1)
            }
            .opacity(configuration.isPressed ? 0.85 : 1)
            .scaleEffect(configuration.isPressed ? 0.99 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }

    private func secondaryFill(isPressed: Bool) -> Color {
        if colorScheme == .dark {
            return Color.pactElevatedSurface.opacity(isPressed ? 0.94 : 1)
        }

        return Color.pactSurface.opacity(isPressed ? 0.9 : 0.74)
    }

    private func secondaryBorder(isPressed: Bool) -> Color {
        if colorScheme == .dark {
            return Color.pactFieldBorder.opacity(isPressed ? 1 : 0.92)
        }

        return Color.pactHairline.opacity(isPressed ? 0.95 : 1)
    }
}
