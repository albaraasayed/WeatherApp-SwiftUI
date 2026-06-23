//
//  SavedLocation.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import Foundation
import SwiftData

// MARK: - SwiftData Model for Saved Locations

/// Represents a user-saved location stored locally via SwiftData.
/// Each saved location stores the city info so we can fetch weather for it later.
@Model
final class SavedLocation {

    /// Unique identifier for each saved location
    var id: UUID

    /// The name of the city (e.g., "Montreal")
    var cityName: String

    /// The country name (e.g., "Canada")
    var country: String

    /// Latitude coordinate for the location
    var latitude: Double

    /// Longitude coordinate for the location
    var longitude: Double

    /// The date this location was saved (used for sorting)
    var dateAdded: Date

    /// Creates a new SavedLocation instance.
    init(
        id: UUID = UUID(),
        cityName: String,
        country: String,
        latitude: Double,
        longitude: Double,
        dateAdded: Date = Date()
    ) {
        self.id = id
        self.cityName = cityName
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
        self.dateAdded = dateAdded
    }
}
