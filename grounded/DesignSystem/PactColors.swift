import SwiftUI
import UIKit

extension Color {
    static let pactBackground = adaptive(
        light: rgb(245, 235, 219),
        dark: rgb(16, 14, 13)
    )
    static let pactBackgroundDeep = adaptive(
        light: rgb(230, 212, 189),
        dark: rgb(28, 23, 21)
    )
    static let pactSurface = adaptive(
        light: rgb(250, 245, 235),
        dark: rgb(38, 31, 28)
    )
    static let pactMutedSurface = adaptive(
        light: rgb(235, 222, 201),
        dark: rgb(50, 41, 37)
    )
    static let pactDarkSurface = adaptive(
        light: rgb(36, 26, 20),
        dark: rgb(22, 18, 16)
    )
    static let pactDarkSurfaceRaised = adaptive(
        light: rgb(54, 38, 28),
        dark: rgb(35, 29, 26)
    )
    static let pactElevatedSurface = adaptive(
        light: rgb(255, 250, 243),
        dark: rgb(60, 50, 45)
    )
    static let pactFieldFill = adaptive(
        light: rgb(255, 255, 255, alpha: 0.30),
        dark: rgb(94, 81, 73, alpha: 0.58)
    )
    static let pactFieldBorder = adaptive(
        light: rgb(82, 61, 46, alpha: 0.16),
        dark: rgb(133, 114, 101, alpha: 0.48)
    )
    static let pactAccent = adaptive(
        light: rgb(158, 51, 20),
        dark: rgb(198, 98, 63)
    )
    static let pactAccentSoft = adaptive(
        light: rgb(214, 133, 84),
        dark: rgb(228, 152, 112)
    )
    static let pactOlive = adaptive(
        light: rgb(89, 99, 64),
        dark: rgb(149, 162, 111)
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
        dark: rgb(122, 101, 86)
    )
    static let pactHairline = adaptive(
        light: rgb(82, 61, 46, alpha: 0.16),
        dark: rgb(219, 199, 178, alpha: 0.18)
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
