//
//  SunriseSunsetWidget.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

// MARK: - Sunrise/Sunset Widget

/// A weather detail widget showing sunrise and sunset times
/// with a sine wave arc graphic representing the sun's path.
struct SunriseSunsetWidget: View {

    // MARK: - Properties

    /// Sunrise time string (e.g., "5:28 AM")
    let sunrise: String

    /// Sunset time string (e.g., "7:25 PM")
    let sunset: String

    // MARK: - Private Computed

    /// Approximate sun position progress (0.0 = sunrise, 1.0 = sunset)
    /// Uses current time to estimate position along the arc.
    private var sunProgress: Double {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"

        guard let sunriseDate = formatter.date(from: sunrise),
              let sunsetDate = formatter.date(from: sunset) else {
            return 0.5
        }

        let calendar = Calendar.current
        let now = Date()

        // Get just the time components for comparison
        let sunriseMinutes = calendar.component(.hour, from: sunriseDate) * 60
            + calendar.component(.minute, from: sunriseDate)
        let sunsetMinutes = calendar.component(.hour, from: sunsetDate) * 60
            + calendar.component(.minute, from: sunsetDate)
        let nowMinutes = calendar.component(.hour, from: now) * 60
            + calendar.component(.minute, from: now)

        let totalDaylight = sunsetMinutes - sunriseMinutes
        guard totalDaylight > 0 else { return 0.5 }

        let elapsed = nowMinutes - sunriseMinutes
        return min(max(Double(elapsed) / Double(totalDaylight), 0), 1.0)
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack(spacing: 4) {
                Image(systemName: "sunrise.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.themeSecondary.opacity(0.6))

                Text("SUNRISE")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.themeSecondary.opacity(0.6))
                    .tracking(0.5)
            }

            // Sunrise time
            Text(sunrise)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)

            Spacer()

            // Sun arc path
            SunArcView(progress: sunProgress)
                .frame(height: 50)

            Spacer()

            // Sunset label
            HStack {
                Text("Sunset: \(sunset)")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.themeSecondary.opacity(0.6))
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 180)
        .glassmorphic(cornerRadius: 22)
    }
}

// MARK: - Sun Arc Shape

/// A sine-wave shaped arc showing the sun's path across the sky.
struct SunArcView: View {

    /// Sun position along the arc (0.0 to 1.0)
    let progress: Double

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height

            ZStack {
                // The arc path
                Path { path in
                    let steps = 100
                    for i in 0...steps {
                        let x = width * Double(i) / Double(steps)
                        let normalizedX = Double(i) / Double(steps)
                        let y = height - (sin(normalizedX * .pi) * height * 0.8) - height * 0.1

                        if i == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(Color.white.opacity(0.3), lineWidth: 2)

                // Horizon dashed line
                Path { path in
                    path.move(to: CGPoint(x: 0, y: height * 0.9))
                    path.addLine(to: CGPoint(x: width, y: height * 0.9))
                }
                .stroke(Color.white.opacity(0.15), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))

                // Sun indicator dot
                let sunX = width * progress
                let sunY = height - (sin(progress * .pi) * height * 0.8) - height * 0.1

                Circle()
                    .fill(Color(hex: "FFD60A"))
                    .frame(width: 14, height: 14)
                    .shadow(color: Color(hex: "FFD60A").opacity(0.6), radius: 6)
                    .position(x: sunX, y: sunY)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        WeatherGradients.darkBackground
            .ignoresSafeArea()

        HStack(spacing: 12) {
            SunriseSunsetWidget(sunrise: "5:28 AM", sunset: "7:25 PM")
            SunriseSunsetWidget(sunrise: "6:00 AM", sunset: "8:15 PM")
        }
        .padding()
    }
}
