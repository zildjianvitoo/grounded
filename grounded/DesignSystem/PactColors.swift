import SwiftUI
import UIKit

extension Color {
    static let pactBackground = adaptive(
        light: rgb(245, 235, 219),
        dark: rgb(21, 18, 16)
    )
    static let pactBackgroundDeep = adaptive(
        light: rgb(230, 212, 189),
        dark: rgb(35, 29, 25)
    )
    static let pactSurface = adaptive(
        light: rgb(250, 245, 235),
        dark: rgb(36, 29, 25)
    )
    static let pactMutedSurface = adaptive(
        light: rgb(235, 222, 201),
        dark: rgb(52, 43, 37)
    )
    static let pactDarkSurface = adaptive(
        light: rgb(36, 26, 20),
        dark: rgb(21, 18, 16)
    )
    static let pactDarkSurfaceRaised = adaptive(
        light: rgb(54, 38, 28),
        dark: rgb(47, 37, 31)
    )
    static let pactAccent = adaptive(
        light: rgb(158, 51, 20),
        dark: rgb(191, 92, 58)
    )
    static let pactAccentSoft = adaptive(
        light: rgb(214, 133, 84),
        dark: rgb(224, 146, 102)
    )
    static let pactOlive = adaptive(
        light: rgb(89, 99, 64),
        dark: rgb(133, 145, 96)
    )
    static let pactTextPrimary = adaptive(
        light: rgb(31, 23, 18),
        dark: rgb(247, 235, 219)
    )
    static let pactTextSecondary = adaptive(
        light: rgb(94, 76, 61),
        dark: rgb(214, 195, 176)
    )
    static let pactTextInverse = adaptive(
        light: rgb(247, 235, 219),
        dark: rgb(250, 245, 235)
    )
    static let pactBorder = adaptive(
        light: rgb(209, 189, 166),
        dark: rgb(107, 86, 70)
    )
    static let pactHairline = adaptive(
        light: rgb(82, 61, 46, alpha: 0.16),
        dark: rgb(255, 255, 255, alpha: 0.14)
    )
    static let pactShadow = adaptive(
        light: rgb(46, 26, 13, alpha: 0.16),
        dark: rgb(0, 0, 0, alpha: 0.34)
    )

    private static func adaptive(light: UIColor, dark: UIColor) -> Color {
        Color(
            uiColor: UIColor { traits in
                traits.userInterfaceStyle == .dark ? dark : light
            }
        )
    }

    private static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        UIColor(
            red: red / 255,
            green: green / 255,
            blue: blue / 255,
            alpha: alpha
        )
    }
}
