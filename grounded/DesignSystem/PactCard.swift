import SwiftUI

enum PactCardStyle {
    case paper
    case muted
    case dark
    case accent
}

struct PactCard<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme
    var style: PactCardStyle = .paper
    var contentPadding: CGFloat = PactSpacing.large
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(contentPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(background, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .stroke(borderColor, lineWidth: 1)
            }
            .shadow(color: shadowColor, radius: 24, x: 0, y: 14)
    }

    private var background: some ShapeStyle {
        switch style {
        case .paper:
            if colorScheme == .dark {
                LinearGradient(
                    colors: [Color.pactSurface, Color.pactElevatedSurface],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            } else {
                LinearGradient(
                    colors: [Color.pactSurface.opacity(0.97), Color.white.opacity(0.52)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        case .muted:
            if colorScheme == .dark {
                LinearGradient(
                    colors: [Color.pactMutedSurface, Color.pactSurface],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            } else {
                LinearGradient(
                    colors: [Color.pactMutedSurface.opacity(0.96), Color.pactSurface.opacity(0.84)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        case .dark:
            LinearGradient(
                colors: [Color.pactDarkSurfaceRaised, Color.pactDarkSurface],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .accent:
            LinearGradient(
                colors: [Color.pactAccentSoft, Color.pactAccent],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    private var borderColor: Color {
        switch style {
        case .paper:
            return colorScheme == .dark ? Color.pactFieldBorder : Color.pactHairline
        case .muted:
            return Color.pactBorder.opacity(0.7)
        case .dark:
            return colorScheme == .dark ? Color.pactBorder.opacity(0.22) : Color.white.opacity(0.08)
        case .accent:
            return colorScheme == .dark ? Color.pactAccentSoft.opacity(0.34) : Color.white.opacity(0.12)
        }
    }

    private var shadowColor: Color {
        switch style {
        case .paper, .muted:
            return Color.pactShadow
        case .dark, .accent:
            return Color.pactShadow.opacity(1.15)
        }
    }
}

struct PactCard_Previews: PreviewProvider {
    static var previews: some View {
        PactScreenContainer {
            PactCard {
                Text("Pact card preview")
            }
        }
    }
}
