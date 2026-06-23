//
//  HumidityWidget.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

struct HumidityWidget: View {

    let humidity: Int

    private var humidityDescription: String {
        if humidity < 30 {
            return "The air is dry right now."
        } else if humidity < 60 {
            return "Comfortable humidity level."
        } else if humidity < 80 {
            return "It's quite humid right now."
        } else {
            return "Very high humidity. Feels muggy."
        }
    }

    private var progress: Double {
        return Double(humidity) / 100.0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Image(systemName: "humidity.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.themeSecondary.opacity(0.6))

                Text("HUMIDITY")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.themeSecondary.opacity(0.6))
                    .tracking(0.5)
            }

            Text("\(humidity)%")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)

            Spacer()

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.white.opacity(0.15))
                        .frame(height: 5)

                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(hex: "40CBD8"))
                        .frame(width: geometry.size.width * progress, height: 5)
                }
            }
            .frame(height: 5)

            Text(humidityDescription)
                .font(.system(size: 14))
                .foregroundStyle(Color.themeSecondary.opacity(0.6))
                .lineLimit(2)
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
            HumidityWidget(humidity: 45)
            HumidityWidget(humidity: 82)
        }
        .padding()
    }
}
