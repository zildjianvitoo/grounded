import Foundation

struct MockFocusContract {
    enum Tone: String, CaseIterable {
        case supportive
        case direct
        case savage

        var displayName: String {
            rawValue.capitalized
        }
    }

    let taskTitle: String
    let durationMinutes: Int
    let whyItMatters: String
    let consequenceText: String
    let tone: Tone

    static let sample = MockFocusContract(
        taskTitle: "Finish the API review notes",
        durationMinutes: 45,
        whyItMatters: "Tomorrow's mentor review will move faster if the thinking is already clear tonight.",
        consequenceText: "If this drifts again, the whole handoff gets heavier and the team pays for your delay.",
        tone: .direct
    )
}

extension MockFocusContract.Tone {
    init(toneType: ToneType) {
        switch toneType {
        case .supportive:
            self = .supportive
        case .direct:
            self = .direct
        case .savage:
            self = .savage
        }
    }

    var toneType: ToneType {
        switch self {
        case .supportive:
            .supportive
        case .direct:
            .direct
        case .savage:
            .savage
        }
    }
}
