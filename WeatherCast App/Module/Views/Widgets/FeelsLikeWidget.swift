//
//  FeelsLikeWidget.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

struct FeelsLikeWidget: View {

    let feelsLike: String

    let actualTemp: String

    private var comparisonText: String {
        let feelsValue = Int(feelsLike.replacingOccurrences(of: "°", with: "")) ?? 0
        let actualValue = Int(actualTemp.replacingOccurrences(of: "°", with: "")) ?? 0

        if feelsValue == actualValue {
            return "Similar to the actual temperature."
        } else if feelsValue > actualValue {
            return "Humidity is making it feel warmer."
        } else {
            return "Wind is making it feel cooler."
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Image(systemName: "thermometer.medium")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.themeSecondary.opacity(0.6))

                Text("FEELS LIKE")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.themeSecondary.opacity(0.6))
                    .tracking(0.5)
            }

            Text(feelsLike)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)

            Spacer()

            Text(comparisonText)
                .font(.system(size: 14))
                .foregroundStyle(Color.themeSecondary.opacity(0.6))
                .lineLimit(3)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 180)
        .glassmorphic(cornerRadius: 22)
    }
}

#Preview {
    ZStack {
        WeatherGradients.darkBackground
            .ignoresSafeArea()

        HStack(spacing: 12) {
            FeelsLikeWidget(feelsLike: "22°", actualTemp: "19°")
            FeelsLikeWidget(feelsLike: "17°", actualTemp: "19°")
        }
        .padding()
    }
}
