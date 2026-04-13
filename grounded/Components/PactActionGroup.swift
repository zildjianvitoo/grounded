import SwiftUI

struct PactActionGroup<Primary: View, Secondary: View>: View {
    @ViewBuilder let primary: Primary
    @ViewBuilder let secondary: Secondary

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: PactSpacing.medium) {
                primary
                secondary
            }

            VStack(spacing: PactSpacing.medium) {
                primary
                secondary
            }
        }
    }
}

struct PactActionGroup_Previews: PreviewProvider {
    static var previews: some View {
        PactScreenContainer {
            PactActionGroup {
                PactPrimaryButton(title: "Primary") {}
            } secondary: {
                PactSecondaryButton(title: "Secondary") {}
            }
        }
    }
}
