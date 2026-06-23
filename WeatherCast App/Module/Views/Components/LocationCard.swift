//
//  LocationCard.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

struct LocationCard: View {

    let cityName: String
    let country: String
    let temperature: Int
    let high: Int
    let low: Int
    let conditionText: String
    let iconName: String

    var onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(temperature)°")
                                .font(.system(size: 52, weight: .thin))
                                .foregroundStyle(.white)

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

                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.trailing, 16)
                    .padding(.top, 16)
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
