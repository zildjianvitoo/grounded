import SwiftUI

struct PactPrimaryButton: View {
    let title: String
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(title, action: action)
            .buttonStyle(PactPrimaryButtonStyle())
            .disabled(!isEnabled)
            .opacity(isEnabled ? 1 : 0.45)
    }
}

struct PactPrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PactScreenContainer {
            VStack(spacing: PactSpacing.medium) {
                PactPrimaryButton(title: "Start Focus Session") {}
                PactPrimaryButton(title: "Disabled State", isEnabled: false) {}
            }
        }
    }
}
