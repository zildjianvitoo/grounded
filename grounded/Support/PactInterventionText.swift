import Foundation

enum PactInterventionText {
    static func notificationTitle(for tone: ToneType) -> String {
        switch tone {
        case .supportive:
            "Stay with it"
        case .direct:
            "Back to the contract"
        case .savage:
            "You wrote this"
        }
    }

    static func notificationBody(for contract: FocusContract) -> String {
        primaryText(for: contract)
    }

    static func replayReminder(for contract: FocusContract) -> String {
        primaryText(for: contract)
    }

    static func replayConsequence(for contract: FocusContract) -> String {
        trimmed(contract.consequenceText)
    }

    private static func primaryText(for contract: FocusContract) -> String {
        let reason = trimmed(contract.whyItMatters)
        if !reason.isEmpty {
            return reason
        }

        return trimmed(contract.consequenceText)
    }

    private static func trimmed(_ text: String) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed
    }
}
