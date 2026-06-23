//
//  HumidityWidget.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

// MARK: - Humidity Widget

/// A weather detail widget showing the current humidity percentage
/// with a visual indicator and dew point description.
struct HumidityWidget: View {

    // MARK: - Properties

    /// Humidity percentage (0-100)
    let humidity: Int

    // MARK: - Private Computed

    /// Description based on humidity level
    private var humidityDescription: String {
        if humidity < 30 {
            return "The air is dry right now."
        } else if humidity < 60 {
            return "Comfortable humidity level."
        } else if humidity < 80 {
            return "It's quite humid right now."
        } else {
            return "Very high humidity. Feels muggy."
        }
    }

    /// Normalized progress for the visual indicator
    private var progress: Double {
        return Double(humidity) / 100.0
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack(spacing: 4) {
                Image(systemName: "humidity.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.themeSecondary.opacity(0.6))

                Text("HUMIDITY")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.themeSecondary.opacity(0.6))
                    .tracking(0.5)
            }

            // Humidity value
            Text("\(humidity)%")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)

            Spacer()

            // Mini progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.white.opacity(0.15))
                        .frame(height: 5)

                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(hex: "40CBD8"))
                        .frame(width: geometry.size.width * progress, height: 5)
                }
            }
            .frame(height: 5)

            // Description
            Text(humidityDescription)
                .font(.system(size: 14))
                .foregroundStyle(Color.themeSecondary.opacity(0.6))
                .lineLimit(2)
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
            HumidityWidget(humidity: 45)
            HumidityWidget(humidity: 82)
        }
        .padding()
    }
}
