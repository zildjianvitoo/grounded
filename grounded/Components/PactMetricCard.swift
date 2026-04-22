import SwiftUI

struct PactMetricCard: View {
    enum Style {
        case paper
        case dark
    }

    let title: String
    let value: String
    let caption: String?
    var style: Style = .paper

    init(title: String, value: String, caption: String? = nil, style: Style = .paper) {
        self.title = title
        self.value = value
        self.caption = caption
        self.style = style
    }

    var body: some View {
        VStack(alignment: .leading, spacing: PactSpacing.small) {
            Text(title.uppercased())
                .font(PactTypography.label)
                .tracking(0.6)
                .foregroundStyle(labelColor)

            Text(value)
                .font(PactTypography.metric)
                .foregroundStyle(valueColor)

            if let caption {
                Text(caption)
                    .font(PactTypography.label)
                    .foregroundStyle(captionColor)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, PactSpacing.medium)
        .padding(.vertical, PactSpacing.large)
        .background(background, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(borderColor, lineWidth: 1)
        }
    }

    private var background: AnyShapeStyle {
        switch style {
        case .paper:
            return AnyShapeStyle(Color.pactSurface)
        case .dark:
            return AnyShapeStyle(LinearGradient(
                colors: [Color.pactDarkSurfaceRaised, Color.pactDarkSurface],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ))
        }
    }

    private var borderColor: Color {
        style == .dark ? Color.white.opacity(0.08) : Color.pactBorder.opacity(0.7)
    }

    private var labelColor: Color {
        style == .dark ? Color.pactAccentSoft.opacity(0.92) : Color.pactTextSecondary.opacity(0.95)
    }

    private var valueColor: Color {
        style == .dark ? Color.pactTextInverse : Color.pactTextPrimary
    }

    private var captionColor: Color {
        style == .dark ? Color.pactTextInverse.opacity(0.72) : Color.pactTextPrimary.opacity(0.82)
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
