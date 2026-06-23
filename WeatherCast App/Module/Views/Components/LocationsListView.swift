//
//  LocationsListView.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

struct LocationsListView: View {

    let locations: [LocationWeatherInfo]

    let isLoading: Bool

    var onLocationTap: (LocationWeatherInfo) -> Void

    var onDelete: (UUID) -> Void

    var body: some View {
        if isLoading {
            ZStack {
                VStack(spacing: 16) {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(1.2)

                    Text("Loading locations...")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.themeSecondary.opacity(0.5))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        } else if locations.isEmpty {
            VStack(spacing: 16) {
                Image(systemName: "mappin.slash")
                    .font(.system(size: 40))
                    .foregroundStyle(Color.themeSecondary.opacity(0.3))

                Text("No saved locations")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.themeSecondary.opacity(0.5))

                Text("Search for a city above to add it")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.themeSecondary.opacity(0.3))
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 80)
        } else {
            LazyVStack(spacing: 16) {
                ForEach(locations) { location in
                    ZStack(alignment: .topLeading) {
                        LocationCard(
                            cityName: location.cityName,
                            country: location.country,
                            temperature: location.temperature,
                            high: location.high,
                            low: location.low,
                            conditionText: location.conditionText,
                            iconName: location.iconName,
                            onTap: {
                                onLocationTap(location)
                            }
                        )
                        
                        Button {
                            onDelete(location.id)
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(.red, .white)
                                .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                        }
                        .offset(x: -8, y: -8)
                    }
                    .contextMenu {
                        Button(role: .destructive) {
                            onDelete(location.id)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    let mockLocations: [LocationWeatherInfo] = [
        LocationWeatherInfo(
            id: UUID(),
            cityName: "Montreal",
            country: "Canada",
            temperature: 19,
            high: 24,
            low: 18,
            conditionText: "Mostly Clear",
            iconName: "Moon",
            latitude: 45.5,
            longitude: -73.6
        ),
        LocationWeatherInfo(
            id: UUID(),
            cityName: "Tokyo",
            country: "Japan",
            temperature: 28,
            high: 32,
            low: 25,
            conditionText: "Partly Cloudy",
            iconName: "Sun_cloud",
            latitude: 35.7,
            longitude: 139.7
        )
    ]

    ZStack {
        WeatherGradients.darkBackground
            .ignoresSafeArea()

        ScrollView {
            LocationsListView(
                locations: mockLocations,
                isLoading: false,
                onLocationTap: { _ in },
                onDelete: { _ in }
            )
        }
    }
}
