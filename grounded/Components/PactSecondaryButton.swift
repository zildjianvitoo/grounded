import SwiftUI

struct PactSecondaryButton: View {
    let title: String
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(title, action: action)
            .buttonStyle(PactSecondaryButtonStyle())
            .disabled(!isEnabled)
            .opacity(isEnabled ? 1 : 0.55)
    }
}

struct PactSecondaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PactScreenContainer {
            VStack(spacing: PactSpacing.medium) {
                PactSecondaryButton(title: "Load Sample Contract") {}
                PactSecondaryButton(title: "Disabled State", isEnabled: false) {}
            }
        }
    }
}
