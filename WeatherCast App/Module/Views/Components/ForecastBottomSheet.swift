//
//  ForecastBottomSheet.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

struct ForecastBottomSheet: View {

    @State private var selectedTab: ForecastTab = .hourly

    let hourlyData: [(time: String, temp: Int, iconName: String, rainChance: String)]

    let weeklyData: [(day: String, temp: Int, iconName: String, rainChance: String, low: Int)]

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

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color.white.opacity(0.3))
                .frame(width: 48, height: 5)
                .padding(.top, 10)
                .padding(.bottom, 8)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    ForecastTabToggler(selectedTab: $selectedTab)
                        .padding(.top, 12)

                    if selectedTab == .hourly {
                        HourlyForecastView(hourlyData: hourlyData)
                            .transition(.opacity)
                    } else {
                        WeeklyForecastView(weeklyData: weeklyData)
                            .transition(.opacity)
                    }

                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 1)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)

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
