import SwiftUI

struct PactMetricCard: View {
    let title: String
    let value: String
    let caption: String?

    init(title: String, value: String, caption: String? = nil) {
        self.title = title
        self.value = value
        self.caption = caption
    }

    var body: some View {
        VStack(alignment: .leading, spacing: PactSpacing.small) {
            Text(title.uppercased())
                .font(PactTypography.label)
                .foregroundStyle(Color.pactTextSecondary)

            Text(value)
                .font(PactTypography.metric)
                .foregroundStyle(Color.pactTextPrimary)

            if let caption {
                Text(caption)
                    .font(PactTypography.label)
                    .foregroundStyle(Color.pactTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(PactSpacing.medium)
        .background(Color.pactMutedSurface, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

struct PactMetricCard_Previews: PreviewProvider {
    static var previews: some View {
        PactScreenContainer {
            PactMetricCard(
                title: "Focused",
                value: "41m",
                caption: "Most of the session stayed on contract"
            )
        }
    }
}
