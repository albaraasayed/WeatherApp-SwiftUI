//
//  WeatherModel.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import Foundation

struct WeatherResponse: Codable {
    let location: Location
    let current: Current
    let forecast: Forecast
}

struct Location: Codable {
    let name: String
    let region: String?
    let country: String?
    let lat: Double?
    let lon: Double?
    let localtime: String?
}

struct Current: Codable {
    let tempC: Double
    let condition: Condition
    let pressureMb: Double?
    let humidity: Int?
    let feelslikeC: Double?
    let visKm: Double?
    let windKph: Double?
    let windDir: String?
    let uv: Double?
    let cloud: Int?
    let precipMm: Double?
    let isDay: Int?
    let airQuality: AirQuality?

    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case condition
        case pressureMb = "pressure_mb"
        case humidity
        case feelslikeC = "feelslike_c"
        case visKm = "vis_km"
        case windKph = "wind_kph"
        case windDir = "wind_dir"
        case uv
        case cloud
        case precipMm = "precip_mm"
        case isDay = "is_day"
        case airQuality = "air_quality"
    }
}

struct Condition: Codable {
    let text: String
    let icon: String?
    let code: Int?
}

struct AirQuality: Codable {
    let co: Double?
    let no2: Double?
    let o3: Double?
    let so2: Double?
    let pm2_5: Double?
    let pm10: Double?
    let usEpaIndex: Int?
    let gbDefraIndex: Int?

    enum CodingKeys: String, CodingKey {
        case co, no2, o3, so2
        case pm2_5 = "pm2_5"
        case pm10
        case usEpaIndex = "us-epa-index"
        case gbDefraIndex = "gb-defra-index"
    }
}

struct Forecast: Codable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable {
    let dateEpoch: Int?
    let date: String
    let day: Day
    let astro: Astro
    let hour: [Hour]

    enum CodingKeys: String, CodingKey {
        case dateEpoch = "date_epoch"
        case date
        case day
        case astro
        case hour
    }
}

struct Day: Codable {
    let maxtempC: Double
    let mintempC: Double
    let avgtempC: Double?
    let avghumidity: Double?
    let dailyChanceOfRain: Int?
    let dailyChanceOfSnow: Int?
    let uv: Double?
    let totalprecipMm: Double?
    let condition: Condition

    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case mintempC = "mintemp_c"
        case avgtempC = "avgtemp_c"
        case avghumidity
        case dailyChanceOfRain = "daily_chance_of_rain"
        case dailyChanceOfSnow = "daily_chance_of_snow"
        case uv
        case totalprecipMm = "totalprecip_mm"
        case condition
    }
}

struct Astro: Codable {
    let sunrise: String?
    let sunset: String?
    let moonrise: String?
    let moonset: String?
    let moonPhase: String?

    enum CodingKeys: String, CodingKey {
        case sunrise
        case sunset
        case moonrise
        case moonset
        case moonPhase = "moon_phase"
    }
}

struct Hour: Codable {
    let timeEpoch: Int?
    let time: String
    let tempC: Double
    let condition: Condition
    let chanceOfRain: Int?
    let chanceOfSnow: Int?
    let humidity: Int?
    let feelslikeC: Double?
    let isDay: Int?
    let windKph: Double?
    let windDir: String?
    let precipMm: Double?

    enum CodingKeys: String, CodingKey {
        case timeEpoch = "time_epoch"
        case time
        case tempC = "temp_c"
        case condition
        case chanceOfRain = "chance_of_rain"
        case chanceOfSnow = "chance_of_snow"
        case humidity
        case feelslikeC = "feelslike_c"
        case isDay = "is_day"
        case windKph = "wind_kph"
        case windDir = "wind_dir"
        case precipMm = "precip_mm"
    }
}
