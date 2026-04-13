import SwiftUI

struct BreakAlertPreviewView: View {
    let title: String
    let bodyText: String

    var body: some View {
        PactCard {
            VStack(alignment: .leading, spacing: PactSpacing.medium) {
                HStack(spacing: PactSpacing.small) {
                    Image(systemName: "bell.badge.fill")
                        .foregroundStyle(Color.pactAccent)

                    Text("Notification Preview")
                        .font(PactTypography.label)
                        .foregroundStyle(Color.pactTextSecondary)

                    Spacer(minLength: 0)

                    Text("now")
                        .font(PactTypography.label)
                        .foregroundStyle(Color.pactTextSecondary)
                }

                VStack(alignment: .leading, spacing: PactSpacing.xSmall) {
                    Text(title)
                        .font(PactTypography.body.weight(.semibold))
                        .foregroundStyle(Color.pactTextPrimary)

                    Text(bodyText)
                        .font(PactTypography.body)
                        .foregroundStyle(Color.pactTextSecondary)
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
