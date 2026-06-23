//
//  HeaderView.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

struct HeaderView: View {

    let cityName: String
    let temperature: String
    let condition: String
    let highTemp: String
    let lowTemp: String
    let isDay: Bool

    var body: some View {
        let textColor = isDay ? Color.black : Color.white

        VStack(spacing: 4) {
            Text(cityName)
                .font(.system(size: 34, weight: .regular))
                .foregroundColor(textColor)

            Text(temperature)
                .font(.system(size: 96, weight: .thin))
                .foregroundColor(textColor)
                .padding(.top, -10)

            Text(condition)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(textColor.opacity(0.7))
                .padding(.top, -8)

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
