//
//  PressureWidget.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

// MARK: - Pressure Widget

/// A weather detail widget showing atmospheric pressure in millibars
/// with a circular dial/gauge UI.
struct PressureWidget: View {

    // MARK: - Properties

    /// Pressure in millibars (typical range: 950-1050)
    let pressureMb: Double

    // MARK: - Private Computed

    /// Normalized progress for the gauge (based on 950-1050 range)
    private var progress: Double {
        let minPressure = 950.0
        let maxPressure = 1050.0
        let normalized = (pressureMb - minPressure) / (maxPressure - minPressure)
        return min(max(normalized, 0), 1.0)
    }

    /// Pressure description
    private var pressureDescription: String {
        if pressureMb < 1000 {
            return "Low"
        } else if pressureMb < 1020 {
            return "Normal"
        } else {
            return "High"
        }
    }

    /// Color based on pressure level
    private var gaugeColor: Color {
        if pressureMb < 1000 {
            return Color(hex: "40CBD8")
        } else if pressureMb < 1020 {
            return Color(hex: "34C759")
        } else {
            return Color(hex: "FF9F0A")
        }
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack(spacing: 4) {
                Image(systemName: "gauge.medium")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.themeSecondary.opacity(0.6))

                Text("PRESSURE")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.themeSecondary.opacity(0.6))
                    .tracking(0.5)
            }

            Spacer()

            // Circular gauge
            ZStack {
                // Background arc (270 degrees)
                Circle()
                    .trim(from: 0, to: 0.75)
                    .stroke(Color.white.opacity(0.15), lineWidth: 6)
                    .rotationEffect(.degrees(135))

                // Progress arc
                Circle()
                    .trim(from: 0, to: progress * 0.75)
                    .stroke(
                        gaugeColor,
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .rotationEffect(.degrees(135))

                // Center content
                VStack(spacing: 2) {
                    Text("\(Int(pressureMb))")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)

                    Text("mb")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(Color.themeSecondary.opacity(0.6))
                }
            }
            .frame(width: 90, height: 90)
            .frame(maxWidth: .infinity)

            // Description
            Text(pressureDescription)
                .font(.system(size: 14))
                .foregroundStyle(Color.themeSecondary.opacity(0.6))
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 180)
        .glassmorphic(cornerRadius: 22)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        WeatherGradients.darkBackground
            .ignoresSafeArea()

        HStack(spacing: 12) {
            PressureWidget(pressureMb: 1012)
            PressureWidget(pressureMb: 985)
        }
        .padding()
    }
}
