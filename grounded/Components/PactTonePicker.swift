import SwiftUI

struct PactTonePicker: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var selection: MockFocusContract.Tone

    var body: some View {
        VStack(alignment: .leading, spacing: PactSpacing.medium) {
            VStack(alignment: .leading, spacing: PactSpacing.xSmall) {
                Text("Reminder Tone")
                    .font(PactTypography.label)
                    .foregroundStyle(Color.pactTextSecondary)

                Text("Changes the preview below.")
                    .font(PactTypography.label)
                    .foregroundStyle(Color.pactTextSecondary.opacity(0.78))
                    .fixedSize(horizontal: false, vertical: true)
            }

            VStack(spacing: PactSpacing.small) {
                ForEach(MockFocusContract.Tone.allCases, id: \.self) { tone in
                    Button {
                        selection = tone
                    } label: {
                        HStack(alignment: .top, spacing: PactSpacing.medium) {
                            Circle()
                                .fill(accentColor(for: tone))
                                .frame(width: 10, height: 10)
                                .padding(.top, 6)

                            VStack(alignment: .leading, spacing: PactSpacing.xSmall) {
                                Text(tone.displayName)
                                    .font(PactTypography.bodyStrong)
                                    .foregroundStyle(Color.pactTextPrimary)

                                Text(description(for: tone))
                                    .font(PactTypography.label)
                                    .foregroundStyle(Color.pactTextSecondary)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                            }

                            Spacer(minLength: 0)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(PactSpacing.medium)
                        .background(backgroundColor(for: tone), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(borderColor(for: tone), lineWidth: tone == selection ? 2 : 1)
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(Text("\(tone.displayName) tone"))
                    .accessibilityHint(Text("Changes the intervention preview below."))
                    .accessibilityAddTraits(tone == selection ? .isSelected : [])
                    .accessibilityValue(Text(tone == selection ? "Selected" : "Not selected"))
                }
            }
        }
    }

    private func description(for tone: MockFocusContract.Tone) -> String {
        switch tone {
        case .supportive:
            "Warm and steady"
        case .direct:
            "Clear and firm"
        case .savage:
            "Sharp and blunt"
        }
    }

    private func backgroundColor(for tone: MockFocusContract.Tone) -> Color {
        if colorScheme == .dark {
            return tone == selection ? Color.pactDarkSurfaceRaised : Color.pactElevatedSurface
        }

        return tone == selection ? Color.pactSurface.opacity(0.95) : Color.white.opacity(0.3)
    }

    private func borderColor(for tone: MockFocusContract.Tone) -> Color {
        if colorScheme == .dark {
            return tone == selection ? Color.pactAccent : Color.pactFieldBorder
        }

        return tone == selection ? Color.pactAccent : Color.pactBorder
    }

    private func accentColor(for tone: MockFocusContract.Tone) -> Color {
        switch tone {
        case .supportive:
            return Color.pactOlive
        case .direct:
            return Color.pactAccent
        case .savage:
            return Color.pactTextPrimary
        }
    }
}

struct PactTonePicker_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var selection: MockFocusContract.Tone = .direct

        var body: some View {
            PactScreenContainer {
                PactTonePicker(selection: $selection)
            }
        }
    }

    static var previews: some View {
        PreviewWrapper()
    }
}
