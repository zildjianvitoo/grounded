import SwiftUI

struct PactStatusBadge: View {
    let text: String

    var body: some View {
        Text(text.uppercased())
            .font(PactTypography.label)
            .foregroundStyle(Color.pactAccent)
            .padding(.horizontal, PactSpacing.medium)
            .padding(.vertical, PactSpacing.small)
            .background(Color.pactAccent.opacity(0.12), in: Capsule())
            .overlay {
                Capsule()
                    .stroke(Color.pactAccent.opacity(0.3), lineWidth: 1)
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
