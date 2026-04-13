import SwiftData

enum PactPreviewContainer {
    static let container: ModelContainer = {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(
                for: FocusContract.self,
                FocusSession.self,
                FocusBreak.self,
                configurations: configuration
            )
        } catch {
            fatalError("Failed to create preview model container: \(error)")
        }
    }()
}
