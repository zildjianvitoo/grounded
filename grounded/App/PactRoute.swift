import Foundation

enum PactRoute: Int, CaseIterable, Identifiable {
    case onboarding
    case contract
    case activeSession
    case replay
    case report

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .onboarding:
            "Onboarding"
        case .contract:
            "Create Contract"
        case .activeSession:
            "Active Session"
        case .replay:
            "Consequence Replay"
        case .report:
            "Reflection Report"
        }
    }

    var eyebrow: String {
        switch self {
        case .onboarding:
            "Step 1"
        case .contract:
            "Step 2"
        case .activeSession:
            "Step 3"
        case .replay:
            "Step 4"
        case .report:
            "Step 5"
        }
    }

    var summary: String {
        switch self {
        case .onboarding:
            "Set the promise and explain how the app keeps the user emotionally anchored."
        case .contract:
            "Capture the task, the reason it matters, and the cost of drifting away from it."
        case .activeSession:
            "Keep the current contract visible with a clear timer and calm focus-first framing."
        case .replay:
            "Bring the user back with a reminder that feels personal, not generic."
        case .report:
            "Close the loop with a short, honest summary of focused time and lost time."
        }
    }

    var previous: PactRoute? {
        PactRoute(rawValue: rawValue - 1)
    }

    var next: PactRoute? {
        PactRoute(rawValue: rawValue + 1)
    }

    var nextInDemoFlow: PactRoute {
        next ?? .onboarding
    }
}
