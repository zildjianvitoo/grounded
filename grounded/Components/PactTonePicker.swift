import SwiftUI

struct PactTonePicker: View {
    @Binding var selection: MockFocusContract.Tone

    var body: some View {
        VStack(alignment: .leading, spacing: PactSpacing.medium) {
            Text("Tone")
                .font(PactTypography.label)
                .foregroundStyle(Color.pactTextSecondary)

            HStack(spacing: PactSpacing.small) {
                ForEach(MockFocusContract.Tone.allCases, id: \.self) { tone in
                    Button {
                        selection = tone
                    } label: {
                        VStack(alignment: .leading, spacing: PactSpacing.xSmall) {
                            Text(tone.displayName)
                                .font(PactTypography.body.weight(.semibold))
                                .foregroundStyle(Color.pactTextPrimary)

                            Text(description(for: tone))
                                .font(PactTypography.label)
                                .foregroundStyle(Color.pactTextSecondary)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
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
                }
            }
        }
    }

    private func description(for tone: MockFocusContract.Tone) -> String {
        switch tone {
        case .supportive:
            "Warm and encouraging"
        case .direct:
            "Clear and firm"
        case .savage:
            "Sharp and confrontational"
        }
    }

    private func backgroundColor(for tone: MockFocusContract.Tone) -> Color {
        tone == selection ? Color.pactSurface : Color.pactMutedSurface.opacity(0.7)
    }

    private func borderColor(for tone: MockFocusContract.Tone) -> Color {
        tone == selection ? Color.pactAccent : Color.pactBorder
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
