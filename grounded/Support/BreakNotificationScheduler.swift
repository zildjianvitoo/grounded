import Foundation
import UserNotifications

enum BreakNotificationScheduler {
    enum AuthorizationState: Equatable {
        case notDetermined
        case authorized
        case denied

        init(status: UNAuthorizationStatus) {
            switch status {
            case .authorized, .provisional, .ephemeral:
                self = .authorized
            case .denied:
                self = .denied
            case .notDetermined:
                self = .notDetermined
            @unknown default:
                self = .denied
            }
        }
    }

    private static let breakNotificationIdentifier = "pact.break.alert"

    static func currentAuthorizationState() async -> AuthorizationState {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return AuthorizationState(status: settings.authorizationStatus)
    }

    static func requestAuthorizationIfNeeded() async -> AuthorizationState {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()

        guard settings.authorizationStatus == .notDetermined else {
            return AuthorizationState(status: settings.authorizationStatus)
        }

        _ = try? await center.requestAuthorization(options: [.alert, .sound, .badge])
        return await currentAuthorizationState()
    }

    static func scheduleBreakAlert(for contract: FocusContract) async {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()

        guard settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional else {
            return
        }

        let content = UNMutableNotificationContent()
        content.title = PactInterventionText.notificationTitle(for: contract.tone)
        content.body = PactInterventionText.notificationBody(for: contract)
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(
            identifier: breakNotificationIdentifier,
            content: content,
            trigger: trigger
        )

        try? await center.add(request)
    }

    static func cancelPendingBreakAlert() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [breakNotificationIdentifier])
    }
}
