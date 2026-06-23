//
//  SavedLocationsViewModel.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import Foundation
import SwiftData

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

@Observable
class SavedLocationsViewModel {

    var searchText: String = ""

    var searchResults: [SearchResult] = []

    var isSearching: Bool = false

    var locationWeatherData: [LocationWeatherInfo] = []

    var isLoadingLocations: Bool = false

    var errorMessage: String?

    private var searchTask: Task<Void, Never>?

    func searchLocations() {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        searchTask?.cancel()
        
        guard query.count >= 2 else {
            searchResults = []
            isSearching = false
            return
        }

        isSearching = true

        searchTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            if Task.isCancelled { return }
            
            do {
                let results = try await SearchService.shared.searchLocations(query: query)
                
                if Task.isCancelled { return }
                
                await MainActor.run {
                    self.searchResults = results
                    self.isSearching = false
                }
            } catch {
                if Task.isCancelled { return }
                
                await MainActor.run {
                    self.searchResults = []
                    self.isSearching = false
                }
            }
        }
    }

    func saveLocation(from result: SearchResult, context: ModelContext) {
        let newLocation = SavedLocation(
            cityName: result.name,
            country: result.country,
            latitude: result.lat,
            longitude: result.lon
        )
        context.insert(newLocation)

        searchText = ""
        searchResults = []

        fetchWeatherForSavedLocations(context: context)
    }

    func deleteLocation(_ location: SavedLocation, context: ModelContext) {
        context.delete(location)

        locationWeatherData.removeAll { $0.id == location.id }
    }

    func deleteLocationById(_ id: UUID, context: ModelContext) {
        let descriptor = FetchDescriptor<SavedLocation>()
        guard let locations = try? context.fetch(descriptor) else { return }

        if let location = locations.first(where: { $0.id == id }) {
            deleteLocation(location, context: context)
        }
    }

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
