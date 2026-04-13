import SwiftUI

struct PactSectionHeader: View {
    let eyebrow: String?
    let title: String
    let supportingText: String

    init(
        eyebrow: String? = nil,
        title: String,
        supportingText: String
    ) {
        self.eyebrow = eyebrow
        self.title = title
        self.supportingText = supportingText
    }

    var body: some View {
        VStack(alignment: .leading, spacing: PactSpacing.small) {
            if let eyebrow {
                Text(eyebrow.uppercased())
                    .font(PactTypography.caption)
                    .foregroundStyle(Color.pactAccent)
            }

            Text(title)
                .font(PactTypography.screenTitle)
                .foregroundStyle(Color.pactTextPrimary)

            Text(supportingText)
                .font(PactTypography.body)
                .foregroundStyle(Color.pactTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct PactSectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        PactScreenContainer {
            PactSectionHeader(
                eyebrow: "Step 2",
                title: "Build the contract before you start",
                supportingText: "A good contract gives the app something honest and personal to say when you drift away."
            )
        }
    }
}
