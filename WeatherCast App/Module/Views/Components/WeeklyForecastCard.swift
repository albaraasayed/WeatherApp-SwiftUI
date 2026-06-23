//
//  WeeklyForecastCard.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

// MARK: - Weekly Forecast Card

/// A pill-shaped card showing a single day's forecast:
/// day name, custom weather icon, rain chance, and temperature.
struct WeeklyForecastCard: View {

    // MARK: - Properties

    let day: String
    let iconName: String
    let rainChance: String
    let temperature: String
    let isToday: Bool

    init(day: String, iconName: String, rainChance: String, temperature: String) {
        self.day = day
        self.iconName = iconName
        self.rainChance = rainChance
        self.temperature = temperature
        self.isToday = (day == "Today")
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 12) {
            // Day name
            Text(day)
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
                    isToday
                    ? WeatherGradients.forecastPillActive
                    : WeatherGradients.forecastPill
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(isToday ? 0.4 : 0.2),
                                    Color.white.opacity(0.05)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: Color(hex: "48319D").opacity(isToday ? 0.5 : 0), radius: 10, y: 5)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        WeatherGradients.darkBackground
            .ignoresSafeArea()

        HStack(spacing: 12) {
            WeeklyForecastCard(
                day: "Today",
                iconName: "Sun",
                rainChance: "10%",
                temperature: "24°"
            )
            WeeklyForecastCard(
                day: "TUE",
                iconName: "Cloud",
                rainChance: "40%",
                temperature: "20°"
            )
            WeeklyForecastCard(
                day: "WED",
                iconName: "Thunder",
                rainChance: "80%",
                temperature: "18°"
            )
        }
    }
}
