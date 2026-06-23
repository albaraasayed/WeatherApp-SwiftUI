//
//  ColorExtension.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let cleanedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")

        var hexValue: UInt64 = 0
        Scanner(string: cleanedHex).scanHexInt64(&hexValue)

        let red: Double
        let green: Double
        let blue: Double
        let alpha: Double

        if cleanedHex.count == 8 {
            red = Double((hexValue >> 24) & 0xFF) / 255.0
            green = Double((hexValue >> 16) & 0xFF) / 255.0
            blue = Double((hexValue >> 8) & 0xFF) / 255.0
            alpha = Double(hexValue & 0xFF) / 255.0
        } else {
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

extension Color {

    static let lightPrimary = Color(hex: "000000")

    static let lightSecondary = Color(hex: "3C3C43")

    static let lightTertiary = Color(hex: "3C3C43")

    static let lightQuaternary = Color(hex: "3C3C43")


    static let darkPrimary = Color(hex: "FFFFFF")

    static let darkSecondary = Color(hex: "EBEBF5")

    static let darkTertiary = Color(hex: "EBEBF5")

    static let darkQuaternary = Color(hex: "EBEBF5")


    static let themePrimary = Color(hex: "FFFFFF")

    static let themeSecondary = Color(hex: "EBEBF5")

    static let themeTertiary = Color(hex: "EBEBF5").opacity(0.6)

    static let themeQuaternary = Color(hex: "EBEBF5").opacity(0.3)
}
