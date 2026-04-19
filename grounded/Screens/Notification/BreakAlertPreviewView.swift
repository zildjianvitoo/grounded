import SwiftUI

struct BreakAlertPreviewView: View {
    let title: String
    let bodyText: String

    var body: some View {
        PactCard(style: .dark) {
            VStack(alignment: .leading, spacing: PactSpacing.medium) {
                HStack(spacing: PactSpacing.small) {
                    Image(systemName: "bell.badge.fill")
                        .foregroundStyle(Color.pactAccentSoft)

                    Text("Notification Preview")
                        .font(PactTypography.label)
                        .foregroundStyle(Color.pactTextInverse.opacity(0.66))

                    Spacer(minLength: 0)

                    Text("now")
                        .font(PactTypography.label)
                        .foregroundStyle(Color.pactTextInverse.opacity(0.66))
                }

                VStack(alignment: .leading, spacing: PactSpacing.xSmall) {
                    Text(title)
                        .font(PactTypography.bodyStrong)
                        .foregroundStyle(Color.pactTextInverse)

                    Text(bodyText)
                        .font(PactTypography.body)
                        .foregroundStyle(Color.pactTextInverse.opacity(0.76))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}

struct BreakAlertPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        PactScreenContainer {
            BreakAlertPreviewView(
                title: "Back to your contract",
                bodyText: "You said this work matters because tomorrow's review depends on what you finish tonight."
            )
        }
    }
}
