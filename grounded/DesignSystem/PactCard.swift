import SwiftUI

struct PactCard<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(PactSpacing.large)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.pactSurface, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(Color.pactBorder, lineWidth: 1)
            }
            .shadow(color: Color.pactShadow, radius: 20, x: 0, y: 10)
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
