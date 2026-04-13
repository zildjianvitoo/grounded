import Foundation

enum ToneType: String, Codable, CaseIterable {
    case supportive
    case direct
    case savage

    var displayName: String {
        rawValue.capitalized
    }
}
