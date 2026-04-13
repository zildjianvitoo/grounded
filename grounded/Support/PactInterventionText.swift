import Foundation

enum PactInterventionText {
    static func notificationTitle(for tone: ToneType) -> String {
        switch tone {
        case .supportive:
            "Come back to your promise"
        case .direct:
            "Back to your contract"
        case .savage:
            "You broke the contract"
        }
    }

    static func notificationBody(for contract: FocusContract) -> String {
        switch contract.tone {
        case .supportive:
            contract.whyItMatters
        case .direct:
            contract.consequenceText
        case .savage:
            "You said this matters. \(contract.consequenceText)"
        }
    }

    static func replayReminder(for contract: FocusContract) -> String {
        "You said this task matters because \(contract.whyItMatters.lowercased())"
    }

    static func replayConsequence(for contract: FocusContract) -> String {
        contract.consequenceText
    }
}
