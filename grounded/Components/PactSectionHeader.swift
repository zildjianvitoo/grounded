import SwiftUI

struct PactSectionHeader: View {
    enum Tone {
        case standard
        case inverse
    }

    let eyebrow: String?
    let title: String
    let supportingText: String?
    var tone: Tone = .standard

    init(
        eyebrow: String? = nil,
        title: String,
        supportingText: String? = nil,
        tone: Tone = .standard
    ) {
        self.eyebrow = eyebrow
        self.title = title
        self.supportingText = supportingText
        self.tone = tone
    }

    var body: some View {
        VStack(alignment: .leading, spacing: PactSpacing.small) {
            if let eyebrow {
                Text(eyebrow.uppercased())
                    .font(PactTypography.caption)
                    .tracking(0.8)
                    .foregroundStyle(eyebrowColor)
            }

            Text(title)
                .font(PactTypography.display)
                .foregroundStyle(titleColor)
                .lineSpacing(1.5)

            if let supportingText, !supportingText.isEmpty {
                Text(supportingText)
                    .font(PactTypography.body)
                    .foregroundStyle(supportingColor)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var eyebrowColor: Color {
        tone == .inverse ? Color.pactTextInverse.opacity(0.82) : Color.pactAccent
    }

    private var titleColor: Color {
        tone == .inverse ? Color.pactTextInverse : Color.pactTextPrimary
    }

    private var supportingColor: Color {
        tone == .inverse ? Color.pactTextInverse.opacity(0.88) : Color.pactTextSecondary
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
