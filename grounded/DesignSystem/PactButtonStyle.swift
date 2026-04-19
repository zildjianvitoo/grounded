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
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.pactTextPrimary.opacity(configuration.isPressed ? 0.9 : 1),
                                Color.pactAccent.opacity(configuration.isPressed ? 0.88 : 1)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .overlay {
                Capsule()
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            }
            .shadow(color: Color.pactShadow.opacity(0.75), radius: 16, x: 0, y: 10)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

struct PactSecondaryButtonStyle: ButtonStyle {
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
                    .fill(Color.pactSurface.opacity(configuration.isPressed ? 0.9 : 0.74))
            )
            .overlay {
                Capsule()
                    .stroke(Color.pactHairline.opacity(configuration.isPressed ? 0.95 : 1), lineWidth: 1)
            }
            .opacity(configuration.isPressed ? 0.85 : 1)
            .scaleEffect(configuration.isPressed ? 0.99 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
