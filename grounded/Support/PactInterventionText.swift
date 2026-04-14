import Foundation

enum PactInterventionText {
    static func notificationTitle(for tone: ToneType) -> String {
        switch tone {
        case .supportive:
            "Come back to what matters"
        case .direct:
            "Back to your contract"
        case .savage:
            "You walked away from the promise"
        }
    }

    static func notificationBody(for contract: FocusContract) -> String {
        switch contract.tone {
        case .supportive:
            "You said this matters because \(normalizedSentence(contract.whyItMatters))"
        case .direct:
            contract.consequenceText
        case .savage:
            "You already named the cost. \(contract.consequenceText)"
        }
    }

    static func replayReminder(for contract: FocusContract) -> String {
        switch contract.tone {
        case .supportive:
            "You said this matters because \(normalizedSentence(contract.whyItMatters))"
        case .direct:
            "You named the reason already: \(normalizedSentence(contract.whyItMatters))"
        case .savage:
            "You wrote the reason yourself: \(normalizedSentence(contract.whyItMatters))"
        }
    }

    static func replayConsequence(for contract: FocusContract) -> String {
        switch contract.tone {
        case .supportive:
            "Stay with it now, before \(normalizedSentence(contract.consequenceText))"
        case .direct:
            contract.consequenceText
        case .savage:
            "You knew the cost when you wrote this: \(contract.consequenceText)"
        }
    }

    private static func normalizedSentence(_ text: String) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let firstCharacter = trimmed.first else {
            return trimmed
        }

        return firstCharacter.lowercased() + trimmed.dropFirst()
    }
}
