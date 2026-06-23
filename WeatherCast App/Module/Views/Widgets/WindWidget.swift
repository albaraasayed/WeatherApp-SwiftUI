//
//  WindWidget.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

// MARK: - Wind Widget

/// A weather detail widget showing wind speed and direction
/// with a compass UI showing the wind direction indicator.
struct WindWidget: View {

    // MARK: - Properties

    /// Wind speed in kph
    let speed: Double

    /// Wind direction abbreviation (e.g., "NE", "SSW")
    let direction: String

    // MARK: - Private Computed

    /// Converts direction string to degrees for the compass indicator
    private var directionDegrees: Double {
        let directionMap: [String: Double] = [
            "N": 0, "NNE": 22.5, "NE": 45, "ENE": 67.5,
            "E": 90, "ESE": 112.5, "SE": 135, "SSE": 157.5,
            "S": 180, "SSW": 202.5, "SW": 225, "WSW": 247.5,
            "W": 270, "WNW": 292.5, "NW": 315, "NNW": 337.5
        ]
        return directionMap[direction] ?? 0
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack(spacing: 4) {
                Image(systemName: "wind")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.themeSecondary.opacity(0.6))

                Text("WIND")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.themeSecondary.opacity(0.6))
                    .tracking(0.5)
            }

            Spacer()

            // Compass
            ZStack {
                // Compass circle
                Circle()
                    .stroke(Color.white.opacity(0.15), lineWidth: 2)

                // Direction markers
                ForEach(["N", "E", "S", "W"], id: \.self) { label in
                    let angle = compassAngle(for: label)
                    Text(label)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color.white.opacity(0.6))
                        .offset(
                            x: cos((angle - 90) * .pi / 180) * 38,
                            y: sin((angle - 90) * .pi / 180) * 38
                        )
                }

                // Tick marks
                ForEach(0..<36, id: \.self) { i in
                    Rectangle()
                        .fill(Color.white.opacity(i % 9 == 0 ? 0.4 : 0.15))
                        .frame(width: 1, height: i % 9 == 0 ? 8 : 4)
                        .offset(y: -30)
                        .rotationEffect(.degrees(Double(i) * 10))
                }

                // Direction arrow
                VStack(spacing: 0) {
                    Triangle()
                        .fill(Color.white)
                        .frame(width: 8, height: 10)

                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 2, height: 20)
                }
                .offset(y: -8)
                .rotationEffect(.degrees(directionDegrees))

                // Center label
                VStack(spacing: 0) {
                    Text("\(Int(speed))")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)

                    Text("km/h")
                        .font(.system(size: 8, weight: .medium))
                        .foregroundStyle(Color.themeSecondary.opacity(0.6))
                }
            }
            .frame(width: 90, height: 90)
            .frame(maxWidth: .infinity)

            Spacer()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 180)
        .glassmorphic(cornerRadius: 22)
    }

    // MARK: - Helpers

    private func compassAngle(for label: String) -> Double {
        switch label {
        case "N": return 0
        case "E": return 90
        case "S": return 180
        case "W": return 270
        default: return 0
        }
    }
}

// MARK: - Triangle Shape

/// A simple triangle shape used for the compass direction arrow.
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        WeatherGradients.darkBackground
            .ignoresSafeArea()

        HStack(spacing: 12) {
            WindWidget(speed: 15.3, direction: "NE")
            WindWidget(speed: 42.0, direction: "SSW")
        }
        .padding()
    }
}
