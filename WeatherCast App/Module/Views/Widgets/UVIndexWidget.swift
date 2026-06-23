//
//  UVIndexWidget.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

// MARK: - UV Index Widget

/// A weather detail widget showing the UV Index with a semi-circular
/// progress bar that is color-coded by UV severity level.
struct UVIndexWidget: View {

    // MARK: - Properties

    /// UV index value (0-11+)
    let uvValue: Double

    /// Description text (e.g., "Low", "Moderate", "High")
    let description: String

    // MARK: - Private Computed

    /// Normalized progress for the arc (0.0 to 1.0), capped at UV 11
    private var progress: Double {
        return min(uvValue / 11.0, 1.0)
    }

    /// Color based on UV level
    private var uvColor: Color {
        if uvValue <= 2 { return Color(hex: "34C759") }       // Low - Green
        if uvValue <= 5 { return Color(hex: "FFD60A") }       // Moderate - Yellow
        if uvValue <= 7 { return Color(hex: "FF9F0A") }       // High - Orange
        if uvValue <= 10 { return Color(hex: "FF3B30") }      // Very High - Red
        return Color(hex: "8B0000")                            // Extreme - Dark Red
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack(spacing: 4) {
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.themeSecondary.opacity(0.6))

                Text("UV INDEX")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.themeSecondary.opacity(0.6))
                    .tracking(0.5)
            }

            // UV Value
            Text("\(Int(uvValue))")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)

            // Description
            Text(description)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)

            Spacer()

            // Semi-circular progress bar
            ZStack {
                // Background arc
                Circle()
                    .trim(from: 0, to: 0.5)
                    .stroke(Color.white.opacity(0.15), lineWidth: 6)
                    .rotationEffect(.degrees(180))

                // Progress arc
                Circle()
                    .trim(from: 0, to: progress * 0.5)
                    .stroke(
                        uvColor,
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .rotationEffect(.degrees(180))

                // Indicator dot at the end
                Circle()
                    .fill(uvColor)
                    .frame(width: 10, height: 10)
                    .shadow(color: uvColor.opacity(0.6), radius: 4)
                    .offset(
                        x: cos(.pi + progress * .pi) * 35,
                        y: sin(.pi + progress * .pi) * 35
                    )
            }
            .frame(width: 80, height: 40)
            .frame(maxWidth: .infinity)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 180)
        .glassmorphic(cornerRadius: 22)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        WeatherGradients.darkBackground
            .ignoresSafeArea()

        HStack(spacing: 12) {
            UVIndexWidget(uvValue: 4, description: "Moderate")
            UVIndexWidget(uvValue: 9, description: "Very High")
        }
        .padding()
    }
}
