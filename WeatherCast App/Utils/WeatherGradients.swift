//
//  WeatherGradients.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

struct WeatherGradients {

    static let darkBackground = LinearGradient(
        colors: [
            Color(hex: "2E335A"),
            Color(hex: "1C1B33")
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let purpleGlow = LinearGradient(
        colors: [
            Color(hex: "5936B4"),
            Color(hex: "362A84")
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let pinkPurpleRadial = RadialGradient(
        colors: [
            Color(hex: "F7CBFD"),
            Color(hex: "7758D1")
        ],
        center: .center,
        startRadius: 0,
        endRadius: 200
    )

    static let purpleAngular = AngularGradient(
        colors: [
            Color(hex: "612FAB").opacity(0.3),
            Color(hex: "612FAB"),
            Color(hex: "612FAB").opacity(0.3)
        ],
        center: .center
    )

    static let glassCard = LinearGradient(
        colors: [
            Color(hex: "2E335A").opacity(0.26),
            Color(hex: "1C1B33").opacity(0.26)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let bottomSheet = LinearGradient(
        colors: [
            Color(hex: "2E335A").opacity(0.90),
            Color(hex: "1C1B33").opacity(0.95)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let locationCard = LinearGradient(
        colors: [
            Color(hex: "5936B4"),
            Color(hex: "362A84")
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let forecastPill = LinearGradient(
        colors: [
            Color(hex: "48319D").opacity(0.4),
            Color(hex: "48319D").opacity(0.1)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let forecastPillActive = LinearGradient(
        colors: [
            Color(hex: "5936B4").opacity(0.8),
            Color(hex: "362A84").opacity(0.8)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let widgetBackground = LinearGradient(
        colors: [
            Color(hex: "2E335A").opacity(0.5),
            Color(hex: "1C1B33").opacity(0.5)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let airQualityBar = LinearGradient(
        colors: [
            Color(hex: "34C759"),
            Color(hex: "FFD60A"),
            Color(hex: "FF9F0A"),
            Color(hex: "FF3B30")
        ],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let uvIndexBar = LinearGradient(
        colors: [
            Color(hex: "34C759"),
            Color(hex: "FFD60A"),
            Color(hex: "FF3B30")
        ],
        startPoint: .leading,
        endPoint: .trailing
    )
}

struct GlassmorphicCard: ViewModifier {
    var cornerRadius: CGFloat = 20

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(WeatherGradients.glassCard)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.3),
                                        Color.white.opacity(0.05)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
    }
}

extension View {
    func glassmorphic(cornerRadius: CGFloat = 20) -> some View {
        self.modifier(GlassmorphicCard(cornerRadius: cornerRadius))
    }
}
