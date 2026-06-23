//
//  LocationCard.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

// MARK: - Location Card

/// A large, gradient-filled, rounded card displaying saved location weather info.
/// Shows city, country, 3D weather icon, temperature, H/L, and condition text.
/// The weather icon protrudes slightly from the top-right of the card.
struct LocationCard: View {

    // MARK: - Properties

    let cityName: String
    let country: String
    let temperature: Int
    let high: Int
    let low: Int
    let conditionText: String
    let iconName: String

    /// Called when the user taps on this card
    var onTap: () -> Void

    // MARK: - Body

    var body: some View {
        Button {
            onTap()
        } label: {
            ZStack(alignment: .topTrailing) {
                // Card background
                VStack(alignment: .leading, spacing: 8) {
                    // Top section: City + Temperature
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            // Temperature (large)
                            Text("\(temperature)°")
                                .font(.system(size: 52, weight: .thin))
                                .foregroundStyle(.white)

                            // City and Country
                            Text(cityName)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.white)

                            Text(country)
                                .font(.system(size: 14))
                                .foregroundStyle(Color.themeSecondary.opacity(0.6))
                        }

                        Spacer()
                    }

                    Spacer()

                    // Bottom section: Condition + H/L
                    HStack {
                        Text(conditionText)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.themeSecondary.opacity(0.7))

                        Spacer()

                        Text("H:\(high)°  L:\(low)°")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.themeSecondary.opacity(0.7))
                    }
                }
                .padding(20)

                // 3D Weather icon protruding from top-right
                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .offset(x: -10, y: -15)
            }
            .frame(height: 170)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(WeatherGradients.locationCard)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.ultraThinMaterial.opacity(0.3))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.25),
                                        Color.white.opacity(0.05)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: Color(hex: "5936B4").opacity(0.3), radius: 15, y: 8)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        WeatherGradients.darkBackground
            .ignoresSafeArea()

        VStack(spacing: 16) {
            LocationCard(
                cityName: "Montreal",
                country: "Canada",
                temperature: 19,
                high: 24,
                low: 18,
                conditionText: "Mostly Clear",
                iconName: "Moon",
                onTap: {}
            )

            LocationCard(
                cityName: "Tokyo",
                country: "Japan",
                temperature: 28,
                high: 32,
                low: 25,
                conditionText: "Partly Cloudy",
                iconName: "Sun_cloud",
                onTap: {}
            )
        }
        .padding()
    }
}
