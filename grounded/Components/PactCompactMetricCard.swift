import SwiftUI

struct PactCompactMetricCard: View {
    let value: String
    let label: String
    @ScaledMetric(relativeTo: .title2) private var valueSize = 28

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.system(size: valueSize, weight: .bold, design: .default))
                .foregroundStyle(Color.pactTextPrimary)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.75)

            Text(label.uppercased())
                .font(PactTypography.label)
                .tracking(1.4)
                .foregroundStyle(Color.pactTextSecondary)
        }
        .frame(maxWidth: .infinity, minHeight: 55, alignment: .topLeading)
        .padding(.horizontal, PactSpacing.medium)
        .padding(.vertical, PactSpacing.medium)
        .background(
            LinearGradient(
                colors: [Color.white.opacity(0.48), Color.pactMutedSurface.opacity(0.88)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 24, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.pactHairline, lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
    }
}

struct PactCompactMetricCard_Previews: PreviewProvider {
    static var previews: some View {
        PactScreenContainer {
            ViewThatFits(in: .horizontal) {
                HStack(spacing: PactSpacing.medium) {
                    PactCompactMetricCard(value: "17:46", label: "Elapsed")
                    PactCompactMetricCard(value: "2", label: "Breaks")
                }

                VStack(spacing: PactSpacing.medium) {
                    PactCompactMetricCard(value: "17:46", label: "Elapsed")
                    PactCompactMetricCard(value: "2", label: "Breaks")
                }
            }
        }
    }
}
