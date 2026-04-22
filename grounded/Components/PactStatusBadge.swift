import SwiftUI

struct PactStatusBadge: View {
    let text: String

    var body: some View {
        HStack(spacing: PactSpacing.small) {
            Circle()
                .fill(Color.pactAccentSoft)
                .frame(width: 8, height: 8)

            Text(text.uppercased())
                .font(PactTypography.label)
                .tracking(0.5)
        }
        .foregroundStyle(Color.pactTextInverse)
        .padding(.horizontal, PactSpacing.medium)
        .padding(.vertical, 11)
        .background(Color.white.opacity(0.08), in: Capsule())
        .overlay {
            Capsule()
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
            }
    }
}

struct PactStatusBadge_Previews: PreviewProvider {
    static var previews: some View {
        PactScreenContainer {
            PactStatusBadge(text: "Focus Active")
        }
    }
}
