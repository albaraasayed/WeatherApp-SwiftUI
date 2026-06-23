//
//  WeatherGradients.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

// MARK: - Weather Gradients

/// A collection of gradient definitions used throughout the app's UI.
struct WeatherGradients {

    // MARK: - Background Gradients

    /// Main dark background gradient: deep navy to near-black
    /// Used as the primary full-screen background.
    static let darkBackground = LinearGradient(
        colors: [
            Color(hex: "2E335A"),
            Color(hex: "1C1B33")
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    /// Purple glow gradient: vibrant purple to dark purple
    /// Used for accent areas and highlighted sections.
    static let purpleGlow = LinearGradient(
        colors: [
            Color(hex: "5936B4"),
            Color(hex: "362A84")
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    // MARK: - Radial Gradients

    /// Pink-purple radial gradient for hero elements
    /// Used behind the main weather artwork.
    static let pinkPurpleRadial = RadialGradient(
        colors: [
            Color(hex: "F7CBFD"),
            Color(hex: "7758D1")
        ],
        center: .center,
        startRadius: 0,
        endRadius: 200
    )

    // MARK: - Angular Gradients

    /// Purple angular gradient for circular UI elements
    /// Used in pressure dials and circular progress indicators.
    static let purpleAngular = AngularGradient(
        colors: [
            Color(hex: "612FAB").opacity(0.3),
            Color(hex: "612FAB"),
            Color(hex: "612FAB").opacity(0.3)
        ],
        center: .center
    )

    // MARK: - Card & Sheet Gradients

    /// Glassmorphic card gradient with subtle transparency
    /// Used for forecast cards and widget backgrounds.
    static let glassCard = LinearGradient(
        colors: [
            Color(hex: "2E335A").opacity(0.26),
            Color(hex: "1C1B33").opacity(0.26)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Bottom sheet background gradient
    /// Used for the forecast bottom sheet overlay.
    static let bottomSheet = LinearGradient(
        colors: [
            Color(hex: "2E335A").opacity(0.90),
            Color(hex: "1C1B33").opacity(0.95)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    /// Location card gradient
    /// Used for saved location cards in the locations screen.
    static let locationCard = LinearGradient(
        colors: [
            Color(hex: "5936B4"),
            Color(hex: "362A84")
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Pill / Forecast Card Gradients

    /// Forecast pill card gradient
    /// A subtle, bordered glassmorphic look for hourly/weekly forecast pills.
    static let forecastPill = LinearGradient(
        colors: [
            Color(hex: "48319D").opacity(0.4),
            Color(hex: "48319D").opacity(0.1)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    /// Active/selected pill card gradient
    /// Brighter gradient for the currently selected forecast pill.
    static let forecastPillActive = LinearGradient(
        colors: [
            Color(hex: "5936B4").opacity(0.8),
            Color(hex: "362A84").opacity(0.8)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    // MARK: - Widget Gradients

    /// Widget background gradient
    /// Used inside the 2-column detail widgets.
    static let widgetBackground = LinearGradient(
        colors: [
            Color(hex: "2E335A").opacity(0.5),
            Color(hex: "1C1B33").opacity(0.5)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Progress Bar Gradients

    /// Air quality progress gradient: green → yellow → orange → red
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

    /// UV Index progress gradient: green → yellow → red
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

// MARK: - Glassmorphic View Modifier

/// A reusable modifier that applies the glassmorphic card style.
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
    /// Applies the glassmorphic card effect with a customizable corner radius.
    func glassmorphic(cornerRadius: CGFloat = 20) -> some View {
        self.modifier(GlassmorphicCard(cornerRadius: cornerRadius))
    }
}
