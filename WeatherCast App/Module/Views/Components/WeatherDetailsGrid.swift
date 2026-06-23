//
//  WeatherDetailsGrid.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

struct WeatherDetailsGrid: View {

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

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        VStack(spacing: 12) {
            AirQualityCard(
                aqiValue: airQualityIndex,
                description: airQualityDescription
            )

            LazyVGrid(columns: columns, spacing: 12) {
                UVIndexWidget(
                    uvValue: uvIndex,
                    description: uvDescription
                )

                SunriseSunsetWidget(
                    sunrise: sunrise,
                    sunset: sunset
                )

                WindWidget(
                    speed: windSpeed,
                    direction: windDirection
                )

                RainfallWidget(
                    rainfallMm: rainfall
                )

                FeelsLikeWidget(
                    feelsLike: feelsLike,
                    actualTemp: actualTemp
                )

                HumidityWidget(
                    humidity: humidity
                )

                VisibilityWidget(
                    visibilityKm: visibility
                )

                PressureWidget(
                    pressureMb: pressure
                )
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    ScrollView {
        ZStack {
            WeatherGradients.darkBackground
                .ignoresSafeArea()

            WeatherDetailsGrid(
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
                visibility: 14.0,
                pressure: 1012,
                airQualityIndex: 2,
                airQualityDescription: "Moderate"
            )
        }
    }
    .background(WeatherGradients.darkBackground)
}
