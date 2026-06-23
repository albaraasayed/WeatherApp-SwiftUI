//
//  SavedLocation.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import Foundation
import SwiftData

@Model
final class SavedLocation {

    var id: UUID

    var cityName: String

    var country: String

    var latitude: Double

    var longitude: Double

    var dateAdded: Date

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
