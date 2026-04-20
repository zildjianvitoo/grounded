import SwiftUI

struct CreateFocusContractView: View {
    private enum Field: Hashable {
        case task
        case duration
    }

    @State private var draft: Draft
    @FocusState private var focusedField: Field?
    let onStartFocus: (Draft) -> Void
    let onDraftChanged: (Draft) -> Void

    init(
        draft: Draft = .empty,
        onStartFocus: @escaping (Draft) -> Void,
        onDraftChanged: @escaping (Draft) -> Void = { _ in }
    ) {
        _draft = State(initialValue: draft)
        self.onStartFocus = onStartFocus
        self.onDraftChanged = onDraftChanged
    }

    var body: some View {
        VStack(alignment: .leading, spacing: PactSpacing.large) {
            PactCard(style: .paper) {
                PactSectionHeader(
                    eyebrow: "Focus Contract",
                    title: "Create your contract",
                    supportingText: "Set the task, time, and stakes before you begin."
                )
            }

            PactCard(style: .paper) {
                VStack(alignment: .leading, spacing: PactSpacing.large) {
                    PactFormField(title: "Task") {
                        HStack(spacing: PactSpacing.small) {
                            TextField("Ship the mentor review prep", text: $draft.taskTitle, axis: .vertical)
                                .font(PactTypography.body)
                                .foregroundStyle(Color.pactTextPrimary)
                                .textInputAutocapitalization(.sentences)
                                .submitLabel(.next)
                                .focused($focusedField, equals: .task)
                                .accessibilityLabel("Task")
                                .onSubmit {
                                    focusedField = .duration
                                }

                            if !draft.taskTitle.isEmpty {
                                Button {
                                    draft.taskTitle = ""
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(Color.pactTextSecondary)
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel("Clear task")
                            }
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
                                    .accessibilityLabel("Duration in minutes")

                                Text("minutes")
                                    .font(PactTypography.body)
                                    .foregroundStyle(Color.pactTextSecondary)

                                Spacer(minLength: 0)
                            }

                            if draft.showsInvalidDurationHint {
                                Text("Enter a duration above 0.")
                                    .font(PactTypography.label)
                                    .foregroundStyle(Color.pactAccent)
                            }
                        }
                    }

                    PactFormField(title: "Why this matters") {
                        PactTextEditor(
                            text: $draft.whyItMatters,
                            prompt: "Why does this matter right now?",
                            accessibilityLabel: "Why this matters"
                        )
                    }

                    PactFormField(title: "What's at stake") {
                        PactTextEditor(
                            text: $draft.consequenceText,
                            prompt: "What gets worse if you drift?",
                            accessibilityLabel: "What is at stake"
                        )
                    }

                    PactTonePicker(selection: $draft.tone)
                }
            }

            PactCard(style: .muted) {
                VStack(alignment: .leading, spacing: PactSpacing.medium) {
                    Text("Reminder Preview")
                        .font(PactTypography.label)
                        .foregroundStyle(Color.pactAccent)

                    Text(previewTitle)
                        .font(PactTypography.bodyStrong)
                        .foregroundStyle(Color.pactTextPrimary)

                    Text(previewBody)
                        .font(PactTypography.body)
                        .foregroundStyle(Color.pactTextSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            PactPrimaryButton(
                title: "Start Session",
                isEnabled: draft.isReady,
                action: { onStartFocus(draft) }
            )
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
            "Stay with it."
        case .direct:
            "Back to the contract."
        case .savage:
            "You wrote this."
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

        return "Your reminder will use what you write above."
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
    @Environment(\.colorScheme) private var colorScheme
    let title: String
    @ViewBuilder let field: Field

    var body: some View {
        VStack(alignment: .leading, spacing: PactSpacing.small) {
            Text(title)
                .font(PactTypography.label)
                .foregroundStyle(Color.pactTextSecondary)

            field
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color.pactFieldFill, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(colorScheme == .dark ? Color.pactFieldBorder : Color.pactHairline, lineWidth: 1)
                }
        }
    }
}

private struct PactTextEditor: View {
    @Binding var text: String
    let prompt: String
    let accessibilityLabel: String

    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(prompt)
                    .font(PactTypography.body)
                    .foregroundStyle(Color.pactTextSecondary.opacity(0.75))
                    .padding(.top, 6)
                    .padding(.leading, 2)
            }

            TextEditor(text: $text)
                .frame(minHeight: 96)
                .scrollContentBackground(.hidden)
                .font(PactTypography.body)
                .foregroundStyle(Color.pactTextPrimary)
                .accessibilityLabel(accessibilityLabel)
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
                    onDraftChanged: { _ in }
                )
            }
            .previewDisplayName("Filled")

            PactScreenContainer {
                CreateFocusContractView(
                    draft: .empty,
                    onStartFocus: { _ in },
                    onDraftChanged: { _ in }
                )
            }
            .previewDisplayName("Empty")

            PactScreenContainer {
                CreateFocusContractView(
                    draft: .filledSample,
                    onStartFocus: { _ in },
                    onDraftChanged: { _ in }
                )
            }
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDisplayName("Landscape")
        }
    }
}
