//
//  SavedLocationsViewModel.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import Foundation
import SwiftData

// MARK: - Location Weather Data

/// Lightweight struct holding weather info for a saved location card.
/// This is NOT a data model — it's a display-only container.
struct LocationWeatherInfo: Identifiable {
    let id: UUID
    let cityName: String
    let country: String
    let temperature: Int
    let high: Int
    let low: Int
    let conditionText: String
    let iconName: String
    let latitude: Double
    let longitude: Double
}

// MARK: - Saved Locations ViewModel

/// ViewModel for the Saved Locations & Search screen.
/// Handles searching via WeatherAPI, saving/deleting via SwiftData,
/// and fetching current weather for each saved location.
@Observable
class SavedLocationsViewModel {

    // MARK: - Properties

    /// Current text in the search bar
    var searchText: String = ""

    /// Results from the WeatherAPI search endpoint
    var searchResults: [SearchResult] = []

    /// Whether a search is in progress
    var isSearching: Bool = false

    /// Weather info for each saved location (used to display cards)
    var locationWeatherData: [LocationWeatherInfo] = []

    /// Whether we're loading weather for saved locations
    var isLoadingLocations: Bool = false

    /// Any error message
    var errorMessage: String?

    // MARK: - Search

    /// Searches for locations matching the current search text.
    func searchLocations() {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard query.count >= 2 else {
            searchResults = []
            return
        }

        isSearching = true

        Task {
            do {
                let results = try await SearchService.shared.searchLocations(query: query)
                await MainActor.run {
                    self.searchResults = results
                    self.isSearching = false
                }
            } catch {
                await MainActor.run {
                    self.searchResults = []
                    self.isSearching = false
                }
            }
        }
    }

    // MARK: - Save & Delete (SwiftData)

    /// Saves a search result as a new location in SwiftData.
    func saveLocation(from result: SearchResult, context: ModelContext) {
        let newLocation = SavedLocation(
            cityName: result.name,
            country: result.country,
            latitude: result.lat,
            longitude: result.lon
        )
        context.insert(newLocation)

        // Clear search after saving
        searchText = ""
        searchResults = []

        // Refresh weather data for the newly saved location
        fetchWeatherForSavedLocations(context: context)
    }

    /// Deletes a saved location from SwiftData.
    func deleteLocation(_ location: SavedLocation, context: ModelContext) {
        context.delete(location)

        // Remove from the weather data array
        locationWeatherData.removeAll { $0.id == location.id }
    }

    /// Deletes a location by its UUID from the weather data.
    func deleteLocationById(_ id: UUID, context: ModelContext) {
        // Fetch the matching location from SwiftData
        let descriptor = FetchDescriptor<SavedLocation>()
        guard let locations = try? context.fetch(descriptor) else { return }

        if let location = locations.first(where: { $0.id == id }) {
            deleteLocation(location, context: context)
        }
    }

    // MARK: - Fetch Weather for Saved Locations

    /// Fetches current weather data for all saved locations.
    /// This is called when the Saved Locations screen appears.
    func fetchWeatherForSavedLocations(context: ModelContext) {
        let descriptor = FetchDescriptor<SavedLocation>(
            sortBy: [SortDescriptor(\.dateAdded, order: .reverse)]
        )

        guard let savedLocations = try? context.fetch(descriptor) else { return }

        isLoadingLocations = true

        Task {
            var weatherItems: [LocationWeatherInfo] = []

            for location in savedLocations {
                do {
                    let response = try await WeatherService.shared.fetchWeather(
                        latitude: location.latitude,
                        longitude: location.longitude
                    )

                    let isDay = response.current.isDay == 1
                    let iconName = WeatherIconMapper.iconName(
                        for: response.current.condition.text,
                        isDay: isDay
                    )

                    let info = LocationWeatherInfo(
                        id: location.id,
                        cityName: location.cityName,
                        country: location.country,
                        temperature: Int(response.current.tempC.rounded()),
                        high: Int(response.forecast.forecastday.first?.day.maxtempC.rounded() ?? 0),
                        low: Int(response.forecast.forecastday.first?.day.mintempC.rounded() ?? 0),
                        conditionText: response.current.condition.text,
                        iconName: iconName,
                        latitude: location.latitude,
                        longitude: location.longitude
                    )
                    weatherItems.append(info)
                } catch {
                    // If fetching fails for one location, add it with placeholder data
                    let info = LocationWeatherInfo(
                        id: location.id,
                        cityName: location.cityName,
                        country: location.country,
                        temperature: 0,
                        high: 0,
                        low: 0,
                        conditionText: "Unavailable",
                        iconName: "Cloud",
                        latitude: location.latitude,
                        longitude: location.longitude
                    )
                    weatherItems.append(info)
                }
            }

            await MainActor.run {
                self.locationWeatherData = weatherItems
                self.isLoadingLocations = false
            }
        }
    }
}
