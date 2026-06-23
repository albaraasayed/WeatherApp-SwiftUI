//
//  ColorExtension.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

// MARK: - Hex Color Initializer

extension Color {
    /// Creates a Color from a hex string (e.g. "FF5733" or "#FF5733").
    init(hex: String) {
        // Remove the "#" if present
        let cleanedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")

        // Parse the hex value
        var hexValue: UInt64 = 0
        Scanner(string: cleanedHex).scanHexInt64(&hexValue)

        let red: Double
        let green: Double
        let blue: Double
        let alpha: Double

        if cleanedHex.count == 8 {
            // RRGGBBAA format
            red = Double((hexValue >> 24) & 0xFF) / 255.0
            green = Double((hexValue >> 16) & 0xFF) / 255.0
            blue = Double((hexValue >> 8) & 0xFF) / 255.0
            alpha = Double(hexValue & 0xFF) / 255.0
        } else {
            // RRGGBB format
            red = Double((hexValue >> 16) & 0xFF) / 255.0
            green = Double((hexValue >> 8) & 0xFF) / 255.0
            blue = Double(hexValue & 0xFF) / 255.0
            alpha = 1.0
        }

        self.init(
            .sRGB,
            red: red,
            green: green,
            blue: blue,
            opacity: alpha
        )
    }
}

// MARK: - Theme Colors

extension Color {

    // MARK: Light Mode Solid Colors

    /// Light mode primary text color: #000000 (Black)
    static let lightPrimary = Color(hex: "000000")

    /// Light mode secondary text color: #3C3C43
    static let lightSecondary = Color(hex: "3C3C43")

    /// Light mode tertiary text color: #3C3C43
    static let lightTertiary = Color(hex: "3C3C43")

    /// Light mode quaternary text color: #3C3C43
    static let lightQuaternary = Color(hex: "3C3C43")

    // MARK: Dark Mode Solid Colors

    /// Dark mode primary text color: #FFFFFF (White)
    static let darkPrimary = Color(hex: "FFFFFF")

    /// Dark mode secondary text color: #EBEBF5
    static let darkSecondary = Color(hex: "EBEBF5")

    /// Dark mode tertiary text color: #EBEBF5
    static let darkTertiary = Color(hex: "EBEBF5")

    /// Dark mode quaternary text color: #EBEBF5
    static let darkQuaternary = Color(hex: "EBEBF5")

    // MARK: Adaptive Theme Colors

    /// Primary text color — adapts to light/dark mode
    static let themePrimary = Color(hex: "FFFFFF")

    /// Secondary text color — adapts to light/dark mode
    static let themeSecondary = Color(hex: "EBEBF5")

    /// Tertiary text color — adapts to light/dark mode
    static let themeTertiary = Color(hex: "EBEBF5").opacity(0.6)

    /// Quaternary text color — adapts to light/dark mode
    static let themeQuaternary = Color(hex: "EBEBF5").opacity(0.3)
}
