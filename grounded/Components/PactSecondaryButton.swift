import SwiftUI

struct PactSecondaryButton: View {
    let title: String
    var systemImage: String? = nil
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            if let systemImage {
                Label(title, systemImage: systemImage)
            } else {
                Text(title)
            }
        }
            .buttonStyle(PactSecondaryButtonStyle())
            .disabled(!isEnabled)
            .opacity(isEnabled ? 1 : 0.55)
    }
}

struct PactSecondaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PactScreenContainer {
            VStack(spacing: PactSpacing.medium) {
                PactSecondaryButton(title: "Edit Contract", systemImage: "square.and.pencil") {}
                PactSecondaryButton(title: "Disabled State", isEnabled: false) {}
            }
        }
    }
}
