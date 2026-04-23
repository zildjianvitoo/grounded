import ActivityKit
import Foundation

struct PactActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var statusText: String
        var startedAt: Date
        var targetEndAt: Date
        var breakStartedAt: Date?
    }

    var sessionID: String
    var taskTitle: String
}
