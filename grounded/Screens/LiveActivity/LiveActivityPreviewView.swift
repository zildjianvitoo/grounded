import SwiftUI

struct LiveActivityPreviewView: View {
    let taskTitle: String
    let timerText: String
    let statusText: String

    var body: some View {
        PactCard(style: .paper) {
            VStack(alignment: .leading, spacing: PactSpacing.medium) {
                HStack {
                    Text("Live Activity")
                        .font(PactTypography.label)
                        .foregroundStyle(Color.pactTextSecondary)

                    Spacer(minLength: 0)

                    PactStatusBadge(text: statusText)
                }

                Text(taskTitle)
                    .font(PactTypography.bodyStrong)
                    .foregroundStyle(Color.pactTextPrimary)
                    .lineLimit(2)

                Text(timerText)
                    .font(PactTypography.display)
                    .foregroundStyle(Color.pactAccent)
            }
        }
    }
}

struct LiveActivityPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        PactScreenContainer {
            LiveActivityPreviewView(
                taskTitle: MockFocusSession.sample.taskTitle,
                timerText: MockFocusSession.sample.remainingTimeText,
                statusText: MockFocusSession.sample.statusLabel
            )
        }
    }
}
