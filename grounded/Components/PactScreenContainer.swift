import SwiftUI

struct PactScreenContainer<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme
    @ViewBuilder let content: Content

    var body: some View {
        ZStack {
            LinearGradient(
                colors: backgroundColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Circle()
                .fill(Color.pactAccentSoft.opacity(colorScheme == .dark ? 0.12 : 0.18))
                .frame(width: 320, height: 320)
                .blur(radius: 24)
                .offset(x: 170, y: -290)

            Circle()
                .fill(Color.pactOlive.opacity(colorScheme == .dark ? 0.10 : 0.12))
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

    private var backgroundColors: [Color] {
        if colorScheme == .dark {
            return [Color.pactBackground, Color.pactBackgroundDeep]
        }

        return [Color.pactBackground, Color.pactBackgroundDeep.opacity(0.92)]
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
