import SwiftUI

struct PactDestructiveButton: View {
    let title: String
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(title, action: action)
            .buttonStyle(PactDestructiveButtonStyle())
            .disabled(!isEnabled)
            .opacity(isEnabled ? 1 : 0.55)
    }
}

struct PactDestructiveButton_Previews: PreviewProvider {
    static var previews: some View {
        PactScreenContainer {
            VStack(spacing: PactSpacing.medium) {
                PactDestructiveButton(title: "End Session") {}
                PactDestructiveButton(title: "Disabled State", isEnabled: false) {}
            }
        }
    }
}
