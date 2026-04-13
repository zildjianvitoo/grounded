import SwiftUI

struct PactScreenContainer<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: PactSpacing.large) {
                content
            }
            .padding(.horizontal, PactSpacing.screenHorizontal)
            .padding(.top, PactSpacing.screenTop)
            .padding(.bottom, PactSpacing.xLarge)
        }
        .background(Color.pactBackground.ignoresSafeArea())
    }
}

struct PactScreenContainer_Previews: PreviewProvider {
    static var previews: some View {
        PactScreenContainer {
            Text("Pact container")
                .font(PactTypography.screenTitle)
        }
    }
}
