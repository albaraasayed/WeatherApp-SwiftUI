//
//  AirQualityCard.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

struct AirQualityCard: View {

    let aqiValue: Int

    let description: String

    private var progress: Double {
        return min(max(Double(aqiValue) / 6.0, 0), 1.0)
    }

    private var indicatorColor: Color {
        switch aqiValue {
        case 1: return Color(hex: "34C759")
        case 2: return Color(hex: "FFD60A")
        case 3: return Color(hex: "FF9F0A")
        case 4: return Color(hex: "FF6B6B")
        case 5: return Color(hex: "FF3B30")
        case 6: return Color(hex: "8B0000")
        default: return Color(hex: "34C759")
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "aqi.medium")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.themeSecondary.opacity(0.6))

                Text("AIR QUALITY")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.themeSecondary.opacity(0.6))
                    .tracking(0.5)
            }

            Text("\(aqiValue) - \(description)")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(WeatherGradients.airQualityBar)
                        .frame(height: 6)

                    Circle()
                        .fill(Color.white)
                        .frame(width: 12, height: 12)
                        .shadow(color: indicatorColor.opacity(0.5), radius: 4)
                        .offset(x: progress * (geometry.size.width - 12))
                }
            }
            .frame(height: 12)

            Text("Air quality index is \(aqiValue), which is \(description.lowercased()).")
                .font(.system(size: 14))
                .foregroundStyle(Color.themeSecondary.opacity(0.6))
                .lineLimit(2)
        }
        .padding(16)
        .glassmorphic(cornerRadius: 22)
    }
}

#Preview {
    ZStack {
        WeatherGradients.darkBackground
            .ignoresSafeArea()

        VStack(spacing: 16) {
            AirQualityCard(aqiValue: 1, description: "Good")
            AirQualityCard(aqiValue: 3, description: "Unhealthy for Sensitive Groups")
        }
        .padding()
    }
}
