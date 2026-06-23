//
//  WeeklyForecastView.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

// MARK: - Weekly Forecast View

/// A horizontal scroll view containing multiple WeeklyForecastCard items.
struct WeeklyForecastView: View {

    // MARK: - Properties

    /// Array of weekly data tuples: (day, temp, iconName, rainChance, low)
    let weeklyData: [(day: String, temp: Int, iconName: String, rainChance: String, low: Int)]

    // MARK: - Body

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(Array(weeklyData.enumerated()), id: \.offset) { index, item in
                    WeeklyForecastCard(
                        day: item.day,
                        iconName: item.iconName,
                        rainChance: item.rainChance,
                        temperature: "\(item.temp)°"
                    )
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

// MARK: - Preview

#Preview {
    // Preview using raw tuples — not the main WeatherModel
    let mockData: [(day: String, temp: Int, iconName: String, rainChance: String, low: Int)] = [
        ("Today", 24, "Sun", "10%", 18),
        ("TUE", 22, "Cloud", "30%", 16),
        ("WED", 20, "Sun_cloud_mid_rain", "60%", 14),
        ("THU", 25, "Sun", "5%", 19),
        ("FRI", 18, "Thunder", "80%", 13),
        ("SAT", 21, "Sun_cloud", "15%", 16),
        ("SUN", 23, "Moon", "0%", 17)
    ]

    ZStack {
        WeatherGradients.darkBackground
            .ignoresSafeArea()

        WeeklyForecastView(weeklyData: mockData)
    }
}
