//
//  WeeklyForecastCard.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

struct WeeklyForecastCard: View {

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

    var body: some View {
        VStack(spacing: 12) {
            Text(day)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)

            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .frame(height: 36)

            Text(rainChance)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color(hex: "40CBD8"))

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
