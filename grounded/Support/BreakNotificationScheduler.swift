import Foundation
import UserNotifications

enum BreakNotificationScheduler {
    private static let breakNotificationIdentifier = "pact.break.alert"

    static func requestAuthorizationIfNeeded() async {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()

        guard settings.authorizationStatus == .notDetermined else {
            return
        }

        _ = try? await center.requestAuthorization(options: [.alert, .sound, .badge])
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
