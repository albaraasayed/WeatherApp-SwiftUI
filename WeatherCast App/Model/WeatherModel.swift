//
//  WeatherModel.swift
//  WeatherCast App
//
//  Created by albaraa alsayed on 08/01/1448 AH.
//

import Foundation

struct WeatherResponse: Codable {
    let location: Location
    let current: Current
    let forecast: Forecast
}

struct Location: Codable {
    let name: String
}

struct Current: Codable {
    let tempC: Double
    let condition: Condition
    let pressureMb: Double
    let humidity: Int
    let feelslikeC: Double
    let visKm: Double

    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case condition
        case pressureMb = "pressure_mb"
        case humidity
        case feelslikeC = "feelslike_c"
        case visKm = "vis_km"
    }
}

struct Condition: Codable {
    let text: String
    let icon: String
}

struct Forecast: Codable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable {
    let dateEpoch: Int
    let day: Day
    let hour: [Hour]

    enum CodingKeys: String, CodingKey {
        case dateEpoch = "date_epoch"
        case day
        case hour
    }
}

struct Day: Codable {
    let maxtempC: Double
    let mintempC: Double
    let condition: Condition

    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case mintempC = "mintemp_c"
        case condition
    }
}

struct Hour: Codable {
    let timeEpoch: Int 
    let time: String
    let tempC: Double
    let condition: Condition

    enum CodingKeys: String, CodingKey {
        case timeEpoch = "time_epoch"
        case time
        case tempC = "temp_c"
        case condition
    }
}
