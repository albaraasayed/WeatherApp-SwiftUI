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
    let isDay: Bool

    // MARK: - Body

    var body: some View {
        let textColor = isDay ? Color.black : Color.white

        VStack(spacing: 4) {
            // City name
            Text(cityName)
                .font(.system(size: 34, weight: .regular))
                .foregroundColor(textColor)

            // Large temperature
            Text(temperature)
                .font(.system(size: 96, weight: .thin))
                .foregroundColor(textColor)
                .padding(.top, -10)

            // Condition text
            Text(condition)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(textColor.opacity(0.7))
                .padding(.top, -8)

            // High / Low
            HStack(spacing: 8) {
                Text(highTemp)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(textColor)

                Text(lowTemp)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(textColor)
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
            lowTemp: "L:18°",
            isDay: true
        )
    }
}
