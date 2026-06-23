//
//  RainfallWidget.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

struct RainfallWidget: View {

    let rainfallMm: Double

    private var contextText: String {
        if rainfallMm == 0 {
            return "No rainfall in the last 24 hours."
        } else if rainfallMm < 2.5 {
            return "Light rainfall expected."
        } else if rainfallMm < 7.5 {
            return "Moderate rainfall expected."
        } else {
            return "Heavy rainfall expected."
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Image(systemName: "drop.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.themeSecondary.opacity(0.6))

                Text("RAINFALL")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.themeSecondary.opacity(0.6))
                    .tracking(0.5)
            }

            Text(String(format: "%.1f mm", rainfallMm))
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)

            Text(contextText)
                .font(.system(size: 14))
                .foregroundStyle(Color.themeSecondary.opacity(0.6))
                .lineLimit(3)

            Spacer()

            HStack(spacing: 6) {
                ForEach(0..<5, id: \.self) { i in
                    Image(systemName: "drop.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(
                            Color(hex: "40CBD8").opacity(
                                rainfallMm > 0
                                ? (Double(i) < rainfallMm / 2.0 ? 0.8 : 0.2)
                                : 0.15
                            )
                        )
                }
            }
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
            RainfallWidget(rainfallMm: 0)
            RainfallWidget(rainfallMm: 6.2)
        }
        .padding()
    }
}
