//
//  LocationsListView.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

// MARK: - Locations List View

/// A vertical scroll view of LocationCard items.
/// Supports swipe-to-delete for removing saved locations.
struct LocationsListView: View {

    // MARK: - Properties

    /// The array of location weather info to display
    let locations: [LocationWeatherInfo]

    /// Whether data is currently loading
    let isLoading: Bool

    /// Called when a location card is tapped
    var onLocationTap: (LocationWeatherInfo) -> Void

    /// Called when a location is deleted (swipe-to-delete)
    var onDelete: (UUID) -> Void

    // MARK: - Body

    var body: some View {
        if isLoading {
            // Loading state
            VStack(spacing: 16) {
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.2)

                Text("Loading locations...")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.themeSecondary.opacity(0.5))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if locations.isEmpty {
            // Empty state
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
            // Location cards list
            LazyVStack(spacing: 16) {
                ForEach(locations) { location in
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

// MARK: - Preview

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
