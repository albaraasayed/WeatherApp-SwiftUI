//
//  HourlyForecastView.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

// MARK: - Hourly Forecast View

/// A horizontal scroll view containing multiple HourlyForecastCard items.
struct HourlyForecastView: View {

    // MARK: - Properties

    /// Array of hourly data tuples: (time, temp, iconName, rainChance)
    let hourlyData: [(time: String, temp: Int, iconName: String, rainChance: String)]

    // MARK: - Body

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(Array(hourlyData.enumerated()), id: \.offset) { index, item in
                    HourlyForecastCard(
                        time: item.time,
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
    let mockData: [(time: String, temp: Int, iconName: String, rainChance: String)] = [
        ("Now", 19, "Sun", "0%"),
        ("2 PM", 20, "Sun_cloud", "10%"),
        ("3 PM", 18, "Cloud", "25%"),
        ("4 PM", 17, "Sun_cloud_mid_rain", "60%"),
        ("5 PM", 16, "Moon_cloud_mid_rain", "70%"),
        ("6 PM", 15, "Moon", "5%")
    ]

    ZStack {
        WeatherGradients.darkBackground
            .ignoresSafeArea()

        HourlyForecastView(hourlyData: mockData)
    }
}
