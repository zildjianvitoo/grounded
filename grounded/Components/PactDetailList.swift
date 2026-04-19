import SwiftUI

struct PactDetailItem: Identifiable, Hashable {
    let label: String
    let value: String

    var id: String { label }
}

struct PactDetailList: View {
    let items: [PactDetailItem]

    var body: some View {
        VStack(alignment: .leading, spacing: PactSpacing.medium) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                if index > 0 {
                    PactSectionDivider()
                }

                PactDetailRow(item: item)
            }
        }
    }
}

private struct PactDetailRow: View {
    let item: PactDetailItem

    var body: some View {
        VStack(alignment: .leading, spacing: PactSpacing.xSmall) {
            Text(item.label.uppercased())
                .font(PactTypography.label)
                .foregroundStyle(Color.pactTextSecondary)

            Text(item.value)
                .font(PactTypography.body)
                .foregroundStyle(Color.pactTextPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct PactDetailList_Previews: PreviewProvider {
    static var previews: some View {
        PactScreenContainer {
            PactCard(style: .paper) {
                PactDetailList(
                    items: [
                        PactDetailItem(label: "Why it matters", value: "Tomorrow's mentor review will move faster if the thinking is already clear tonight."),
                        PactDetailItem(label: "What is at stake", value: "If this drifts again, the handoff gets heavier and the team pays for your delay."),
                        PactDetailItem(label: "Tone", value: "Direct")
                    ]
                )
            }
        }
    }
}
