//
//  ForecastBottomSheet.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

// MARK: - Forecast Bottom Sheet

/// A custom bottom sheet with a drag handle that contains the forecast
/// tab toggler, hourly/weekly forecast views, and the weather details grid.
/// Uses an ultra-thin material background with a purple tint.
struct ForecastBottomSheet: View {

    // MARK: - Properties

    /// The currently selected forecast tab
    @State private var selectedTab: ForecastTab = .hourly

    /// Hourly forecast data from the ViewModel
    let hourlyData: [(time: String, temp: Int, iconName: String, rainChance: String)]

    /// Weekly forecast data from the ViewModel
    let weeklyData: [(day: String, temp: Int, iconName: String, rainChance: String, low: Int)]

    /// Weather detail values for the grid
    let uvIndex: Double
    let uvDescription: String
    let sunrise: String
    let sunset: String
    let windSpeed: Double
    let windDirection: String
    let rainfall: Double
    let feelsLike: String
    let actualTemp: String
    let humidity: Int
    let visibility: Double
    let pressure: Double
    let airQualityIndex: Int
    let airQualityDescription: String

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            // Drag handle
            Capsule()
                .fill(Color.white.opacity(0.3))
                .frame(width: 48, height: 5)
                .padding(.top, 10)
                .padding(.bottom, 8)

            // Scrollable content
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    ForecastTabToggler(selectedTab: $selectedTab)
                        .padding(.top, 12)

                    // Forecast content based on selected tab
                    if selectedTab == .hourly {
                        HourlyForecastView(hourlyData: hourlyData)
                            .transition(.opacity)
                    } else {
                        WeeklyForecastView(weeklyData: weeklyData)
                            .transition(.opacity)
                    }

                    // Separator
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 1)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)

                    // Weather details grid
                    WeatherDetailsGrid(
                        uvIndex: uvIndex,
                        uvDescription: uvDescription,
                        sunrise: sunrise,
                        sunset: sunset,
                        windSpeed: windSpeed,
                        windDirection: windDirection,
                        rainfall: rainfall,
                        feelsLike: feelsLike,
                        actualTemp: actualTemp,
                        humidity: humidity,
                        visibility: visibility,
                        pressure: pressure,
                        airQualityIndex: airQualityIndex,
                        airQualityDescription: airQualityDescription
                    )

                    // Bottom spacing
                    Spacer()
                        .frame(height: 40)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 44)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 44)
                        .fill(WeatherGradients.bottomSheet)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 44)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.3),
                                    Color.white.opacity(0.05)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1
                        )
                )
                .ignoresSafeArea(.all, edges: .bottom)
        )
        .clipShape(RoundedRectangle(cornerRadius: 44))
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

// MARK: - Preview

#Preview {
    let mockHourly: [(time: String, temp: Int, iconName: String, rainChance: String)] = [
        ("Now", 19, "Sun", "0%"),
        ("2 PM", 20, "Sun_cloud", "10%"),
        ("3 PM", 18, "Cloud", "25%"),
        ("4 PM", 17, "Sun_cloud_mid_rain", "60%")
    ]

    let mockWeekly: [(day: String, temp: Int, iconName: String, rainChance: String, low: Int)] = [
        ("Today", 24, "Sun", "10%", 18),
        ("TUE", 22, "Cloud", "30%", 16),
        ("WED", 20, "Sun_cloud_mid_rain", "60%", 14)
    ]

    ZStack {
        WeatherGradients.darkBackground
            .ignoresSafeArea()

        VStack {
            Spacer()

            ForecastBottomSheet(
                hourlyData: mockHourly,
                weeklyData: mockWeekly,
                uvIndex: 4,
                uvDescription: "Moderate",
                sunrise: "5:28 AM",
                sunset: "7:25 PM",
                windSpeed: 15.3,
                windDirection: "NE",
                rainfall: 2.5,
                feelsLike: "22°",
                actualTemp: "19°",
                humidity: 65,
                visibility: 14,
                pressure: 1012,
                airQualityIndex: 2,
                airQualityDescription: "Moderate"
            )
            .frame(height: 500)
        }
    }
}
