//
//  VisibilityWidget.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

// MARK: - Visibility Widget

/// A weather detail widget showing the current visibility distance
/// in kilometers with a contextual description.
struct VisibilityWidget: View {

    // MARK: - Properties

    /// Visibility in kilometers
    let visibilityKm: Double

    // MARK: - Private Computed

    /// Description based on visibility level
    private var visibilityDescription: String {
        if visibilityKm >= 10 {
            return "It's perfectly clear right now."
        } else if visibilityKm >= 5 {
            return "Good visibility conditions."
        } else if visibilityKm >= 2 {
            return "Moderate visibility. Be careful driving."
        } else if visibilityKm >= 1 {
            return "Poor visibility. Fog or haze likely."
        } else {
            return "Very poor visibility. Take extra caution."
        }
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack(spacing: 4) {
                Image(systemName: "eye.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.themeSecondary.opacity(0.6))

                Text("VISIBILITY")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.themeSecondary.opacity(0.6))
                    .tracking(0.5)
            }

            // Visibility value
            Text(String(format: "%.0f km", visibilityKm))
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)

            Spacer()

            // Description
            Text(visibilityDescription)
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

// MARK: - Preview

#Preview {
    ZStack {
        WeatherGradients.darkBackground
            .ignoresSafeArea()

        HStack(spacing: 12) {
            VisibilityWidget(visibilityKm: 14.0)
            VisibilityWidget(visibilityKm: 3.5)
        }
        .padding()
    }
}
