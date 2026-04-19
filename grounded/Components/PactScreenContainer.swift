import SwiftUI

struct PactScreenContainer<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.pactBackground, Color.pactBackgroundDeep.opacity(0.92)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Circle()
                .fill(Color.pactAccentSoft.opacity(0.18))
                .frame(width: 320, height: 320)
                .blur(radius: 24)
                .offset(x: 170, y: -290)

            Circle()
                .fill(Color.pactOlive.opacity(0.12))
                .frame(width: 260, height: 260)
                .blur(radius: 22)
                .offset(x: -170, y: -120)

            ScrollView {
                VStack(alignment: .leading, spacing: PactSpacing.large) {
                    content
                }
                .padding(.horizontal, PactSpacing.screenHorizontal)
                .padding(.top, PactSpacing.screenTop)
                .padding(.bottom, PactSpacing.xLarge)
            }
        }
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
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
