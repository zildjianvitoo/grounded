import SwiftUI

struct PactSectionDivider: View {
    enum Tone {
        case standard
        case inverse
    }

    var tone: Tone = .standard

    var body: some View {
        Rectangle()
            .fill(tone == .inverse ? Color.white.opacity(0.14) : Color.pactBorder)
            .frame(height: 1)
            .frame(maxWidth: .infinity)
            .accessibilityHidden(true)
    }
}

struct PactSectionDivider_Previews: PreviewProvider {
    static var previews: some View {
        PactScreenContainer {
            VStack(spacing: PactSpacing.large) {
                PactSectionDivider()
                PactSectionDivider(tone: .inverse)
            }
        }
    }
}
