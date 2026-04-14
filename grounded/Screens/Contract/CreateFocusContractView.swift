import SwiftUI

struct CreateFocusContractView: View {
    private enum Field: Hashable {
        case task
        case duration
    }

    @State private var draft: Draft
    @FocusState private var focusedField: Field?
    let onStartFocus: (Draft) -> Void
    let onLoadSample: () -> Void
    let onDraftChanged: (Draft) -> Void

    init(
        draft: Draft = .filledSample,
        onStartFocus: @escaping (Draft) -> Void,
        onLoadSample: @escaping () -> Void,
        onDraftChanged: @escaping (Draft) -> Void = { _ in }
    ) {
        _draft = State(initialValue: draft)
        self.onStartFocus = onStartFocus
        self.onLoadSample = onLoadSample
        self.onDraftChanged = onDraftChanged
    }

    var body: some View {
        VStack(alignment: .leading, spacing: PactSpacing.large) {
            PactCard {
                PactSectionHeader(
                    eyebrow: "Focus Contract",
                    title: "Build the contract before you begin",
                    supportingText: "A stronger contract gives the app a more honest way to pull you back when you break focus."
                )
            }

            PactCard {
                VStack(alignment: .leading, spacing: PactSpacing.large) {
                    PactFormField(title: "Task") {
                        TextField("Ship the mentor review prep", text: $draft.taskTitle, axis: .vertical)
                            .font(PactTypography.body)
                            .foregroundStyle(Color.pactTextPrimary)
                            .textInputAutocapitalization(.sentences)
                            .submitLabel(.next)
                            .focused($focusedField, equals: .task)
                            .onSubmit {
                                focusedField = .duration
                            }
                    }

                    PactFormField(title: "Duration") {
                        VStack(alignment: .leading, spacing: PactSpacing.small) {
                            HStack(spacing: PactSpacing.small) {
                                TextField("45", text: $draft.durationMinutes)
                                    .keyboardType(.numberPad)
                                    .font(PactTypography.body)
                                    .foregroundStyle(Color.pactTextPrimary)
                                    .focused($focusedField, equals: .duration)

                                Text("minutes")
                                    .font(PactTypography.body)
                                    .foregroundStyle(Color.pactTextSecondary)

                                Spacer(minLength: 0)
                            }

                            if draft.showsInvalidDurationHint {
                                Text("Enter a duration greater than 0 minutes.")
                                    .font(PactTypography.label)
                                    .foregroundStyle(Color.pactAccent)
                            }
                        }
                    }

                    PactFormField(title: "Why this matters") {
                        PactTextEditor(text: $draft.whyItMatters, prompt: "Tomorrow's review gets easier if tonight's thinking is already clear.")
                    }

                    PactFormField(title: "What is at stake") {
                        PactTextEditor(text: $draft.consequenceText, prompt: "If this slips again, the whole handoff gets heavier for the team.")
                    }

                    PactTonePicker(selection: $draft.tone)
                }
            }

            PactCard {
                VStack(alignment: .leading, spacing: PactSpacing.medium) {
                    Text("Intervention Preview")
                        .font(PactTypography.label)
                        .foregroundStyle(Color.pactTextSecondary)

                    Text(previewTitle)
                        .font(PactTypography.body.weight(.semibold))
                        .foregroundStyle(Color.pactTextPrimary)

                    Text(previewBody)
                        .font(PactTypography.body)
                        .foregroundStyle(Color.pactTextSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            PactActionGroup {
                PactPrimaryButton(
                    title: "Start Focus Session",
                    isEnabled: draft.isReady,
                    action: { onStartFocus(draft) }
                )
            } secondary: {
                PactSecondaryButton(title: "Load Sample Contract", action: {
                    draft = .filledSample
                    onDraftChanged(draft)
                    onLoadSample()
                })
            }
        }
        .onAppear {
            onDraftChanged(draft)
        }
        .onChange(of: draft) { _, updatedDraft in
            onDraftChanged(updatedDraft)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                if focusedField == .duration {
                    Spacer()

                    Button("Done") {
                        focusedField = nil
                    }
                }
            }
        }
    }

    private var previewTitle: String {
        switch draft.tone {
        case .supportive:
            "Stay with the promise."
        case .direct:
            "Back to the contract."
        case .savage:
            "You wrote this. Honor it."
        }
    }

    private var previewBody: String {
        let reason = draft.whyItMatters.trimmingCharacters(in: .whitespacesAndNewlines)
        let consequence = draft.consequenceText.trimmingCharacters(in: .whitespacesAndNewlines)

        if !reason.isEmpty {
            return reason
        }

        if !consequence.isEmpty {
            return consequence
        }

        return "The app will turn your own reason and consequence into the reminder that brings you back."
    }
}

extension CreateFocusContractView {
    struct Draft: Equatable {
        var taskTitle: String
        var durationMinutes: String
        var whyItMatters: String
        var consequenceText: String
        var tone: MockFocusContract.Tone

        init(
            taskTitle: String,
            durationMinutes: String,
            whyItMatters: String,
            consequenceText: String,
            tone: MockFocusContract.Tone
        ) {
            self.taskTitle = taskTitle
            self.durationMinutes = durationMinutes
            self.whyItMatters = whyItMatters
            self.consequenceText = consequenceText
            self.tone = tone
        }

        var isReady: Bool {
            !taskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            parsedDurationMinutes != nil &&
            !whyItMatters.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            !consequenceText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }

        var parsedDurationMinutes: Int? {
            guard let minutes = Int(durationMinutes.trimmingCharacters(in: .whitespacesAndNewlines)), minutes > 0 else {
                return nil
            }

            return minutes
        }

        var showsInvalidDurationHint: Bool {
            let trimmed = durationMinutes.trimmingCharacters(in: .whitespacesAndNewlines)
            return !trimmed.isEmpty && parsedDurationMinutes == nil
        }

        static let empty = Draft(
            taskTitle: "",
            durationMinutes: "",
            whyItMatters: "",
            consequenceText: "",
            tone: .supportive
        )

        static let filledSample = Draft(
            taskTitle: MockFocusContract.sample.taskTitle,
            durationMinutes: "\(MockFocusContract.sample.durationMinutes)",
            whyItMatters: MockFocusContract.sample.whyItMatters,
            consequenceText: MockFocusContract.sample.consequenceText,
            tone: MockFocusContract.sample.tone
        )

        init(contract: FocusContract) {
            self.taskTitle = contract.taskTitle
            self.durationMinutes = "\(contract.durationMinutes)"
            self.whyItMatters = contract.whyItMatters
            self.consequenceText = contract.consequenceText
            self.tone = .init(toneType: contract.tone)
        }
    }
}

private struct PactFormField<Field: View>: View {
    let title: String
    @ViewBuilder let field: Field

    var body: some View {
        VStack(alignment: .leading, spacing: PactSpacing.small) {
            Text(title)
                .font(PactTypography.label)
                .foregroundStyle(Color.pactTextSecondary)

            field
                .padding(PactSpacing.medium)
                .background(Color.pactMutedSurface.opacity(0.7), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
    }
}

private struct PactTextEditor: View {
    @Binding var text: String
    let prompt: String

    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(prompt)
                    .font(PactTypography.body)
                    .foregroundStyle(Color.pactTextSecondary.opacity(0.75))
                    .padding(.top, 8)
                    .padding(.leading, 4)
            }

            TextEditor(text: $text)
                .frame(minHeight: 110)
                .scrollContentBackground(.hidden)
                .font(PactTypography.body)
                .foregroundStyle(Color.pactTextPrimary)
        }
    }
}

struct CreateFocusContractView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PactScreenContainer {
                CreateFocusContractView(
                    draft: .filledSample,
                    onStartFocus: { _ in },
                    onLoadSample: {},
                    onDraftChanged: { _ in }
                )
            }
            .previewDisplayName("Filled")

            PactScreenContainer {
                CreateFocusContractView(
                    draft: .empty,
                    onStartFocus: { _ in },
                    onLoadSample: {},
                    onDraftChanged: { _ in }
                )
            }
            .previewDisplayName("Empty")

            PactScreenContainer {
                CreateFocusContractView(
                    draft: .filledSample,
                    onStartFocus: { _ in },
                    onLoadSample: {},
                    onDraftChanged: { _ in }
                )
            }
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDisplayName("Landscape")
        }
    }
}
