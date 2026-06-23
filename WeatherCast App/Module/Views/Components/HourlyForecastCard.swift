//
//  HourlyForecastCard.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

// MARK: - Hourly Forecast Card

/// A pill-shaped card showing a single hour's forecast:
/// time, custom weather icon, rain chance, and temperature.
struct HourlyForecastCard: View {

    // MARK: - Properties

    let time: String
    let iconName: String
    let rainChance: String
    let temperature: String
    let isNow: Bool

    init(time: String, iconName: String, rainChance: String, temperature: String) {
        self.time = time
        self.iconName = iconName
        self.rainChance = rainChance
        self.temperature = temperature
        self.isNow = (time == "Now")
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 12) {
            // Time label
            Text(time)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)

            // Weather icon
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .frame(height: 36)

            // Rain chance
            Text(rainChance)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color(hex: "40CBD8"))

            // Temperature
            Text(temperature)
                .font(.system(size: 20, weight: .regular))
                .foregroundStyle(.white)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .frame(width: 72)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(
                    isNow
                    ? WeatherGradients.forecastPillActive
                    : WeatherGradients.forecastPill
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(isNow ? 0.4 : 0.2),
                                    Color.white.opacity(0.05)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: Color(hex: "48319D").opacity(isNow ? 0.5 : 0), radius: 10, y: 5)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        WeatherGradients.darkBackground
            .ignoresSafeArea()

        HStack(spacing: 12) {
            HourlyForecastCard(
                time: "Now",
                iconName: "Sun",
                rainChance: "0%",
                temperature: "19°"
            )
            HourlyForecastCard(
                time: "2 PM",
                iconName: "Cloud",
                rainChance: "30%",
                temperature: "17°"
            )
            HourlyForecastCard(
                time: "3 PM",
                iconName: "Sun_cloud_mid_rain",
                rainChance: "60%",
                temperature: "16°"
            )
        }
    }
}
