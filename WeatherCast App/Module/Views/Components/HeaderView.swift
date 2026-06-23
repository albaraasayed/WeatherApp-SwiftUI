//
//  HeaderView.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

// MARK: - Header View

/// Displays the city name, large current temperature, condition text,
/// and High/Low temperatures at the top of the main weather screen.
struct HeaderView: View {

    // MARK: - Properties

    let cityName: String
    let temperature: String
    let condition: String
    let highTemp: String
    let lowTemp: String

    // MARK: - Body

    var body: some View {
        VStack(spacing: 4) {
            // City name
            Text(cityName)
                .font(.system(size: 34, weight: .regular))
                .foregroundStyle(.white)

            // Large temperature
            Text(temperature)
                .font(.system(size: 96, weight: .thin))
                .foregroundStyle(.white)
                .padding(.top, -10)

            // Condition text
            Text(condition)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.themeSecondary.opacity(0.7))
                .padding(.top, -8)

            // High / Low
            HStack(spacing: 8) {
                Text(highTemp)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)

                Text(lowTemp)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
            }
        }
    }
}

// MARK: - Preview

/// Preview uses raw strings — not the main WeatherModel.
#Preview {
    ZStack {
        WeatherGradients.darkBackground
            .ignoresSafeArea()

        HeaderView(
            cityName: "Montreal",
            temperature: "19°",
            condition: "Mostly Clear",
            highTemp: "H:24°",
            lowTemp: "L:18°"
        )
    }
}
