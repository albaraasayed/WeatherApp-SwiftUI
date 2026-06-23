//
//  WeatherViewModel.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import Foundation
import CoreLocation

// MARK: - Weather ViewModel

/// Main ViewModel that manages weather data for the Home screen.
/// Uses @Observable (iOS 17+) for automatic SwiftUI updates.
@Observable
class WeatherViewModel: NSObject, CLLocationManagerDelegate {

    // MARK: - Published Properties

    /// The full weather response from the API
    var weather: WeatherResponse?

    /// Whether a network request is in progress
    var isLoading: Bool = false

    /// Any error message to display to the user
    var errorMessage: String?

    /// The current city being displayed
    var currentCity: String = "Montreal"

    // MARK: - Location Manager

    private let locationManager = CLLocationManager()
    private var hasRequestedLocation = false

    // MARK: - Init

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    // MARK: - Computed Properties (Current Weather)

    /// Current temperature as a rounded integer string (e.g., "19°")
    var currentTemperature: String {
        guard let temp = weather?.current.tempC else { return "--°" }
        return "\(Int(temp.rounded()))°"
    }

    /// Current condition text (e.g., "Partly Cloudy")
    var conditionText: String {
        return weather?.current.condition.text ?? "Loading..."
    }

    /// Today's high temperature (e.g., "H:24°")
    var highTemperature: String {
        guard let day = weather?.forecast.forecastday.first?.day else { return "H:--°" }
        return "H:\(Int(day.maxtempC.rounded()))°"
    }

    /// Today's low temperature (e.g., "L:12°")
    var lowTemperature: String {
        guard let day = weather?.forecast.forecastday.first?.day else { return "L:--°" }
        return "L:\(Int(day.mintempC.rounded()))°"
    }

    /// The custom icon asset name for current conditions
    var currentIconName: String {
        guard let weather = weather else { return "Sun" }
        let isDay = weather.current.isDay == 1
        return WeatherIconMapper.iconName(for: weather.current.condition.text, isDay: isDay)
    }

    /// Whether it's currently daytime
    var isDay: Bool {
        return weather?.current.isDay == 1
    }

    // MARK: - Computed Properties (Details)

    /// UV Index value
    var uvIndex: Double {
        return weather?.current.uv ?? 0
    }

    /// UV Index description text
    var uvDescription: String {
        let uv = uvIndex
        if uv <= 2 { return "Low" }
        if uv <= 5 { return "Moderate" }
        if uv <= 7 { return "High" }
        if uv <= 10 { return "Very High" }
        return "Extreme"
    }

    /// Sunrise time string (e.g., "5:28 AM")
    var sunriseTime: String {
        return weather?.forecast.forecastday.first?.astro.sunrise ?? "--:--"
    }

    /// Sunset time string (e.g., "7:25 PM")
    var sunsetTime: String {
        return weather?.forecast.forecastday.first?.astro.sunset ?? "--:--"
    }

    /// Wind speed in kph
    var windSpeed: Double {
        return weather?.current.windKph ?? 0
    }

    /// Wind direction (e.g., "NE")
    var windDirection: String {
        return weather?.current.windDir ?? "N"
    }

    /// Rainfall in mm
    var rainfall: Double {
        return weather?.current.precipMm ?? 0
    }

    /// Feels like temperature as integer string
    var feelsLike: String {
        guard let feels = weather?.current.feelslikeC else { return "--°" }
        return "\(Int(feels.rounded()))°"
    }

    /// Humidity percentage
    var humidity: Int {
        return weather?.current.humidity ?? 0
    }

    /// Visibility in km
    var visibility: Double {
        return weather?.current.visKm ?? 0
    }

    /// Pressure in millibars
    var pressure: Double {
        return weather?.current.pressureMb ?? 0
    }

    /// Air quality US EPA index (1-6 scale)
    var airQualityIndex: Int {
        return weather?.current.airQuality?.usEpaIndex ?? 1
    }

    /// Air quality description text
    var airQualityDescription: String {
        switch airQualityIndex {
        case 1: return "Good"
        case 2: return "Moderate"
        case 3: return "Unhealthy for Sensitive Groups"
        case 4: return "Unhealthy"
        case 5: return "Very Unhealthy"
        case 6: return "Hazardous"
        default: return "Good"
        }
    }

    // MARK: - Computed Properties (Forecast)

    /// Hourly forecast data for today and tomorrow, filtered to future hours.
    var hourlyForecast: [(time: String, temp: Int, iconName: String, rainChance: String)] {
        guard let forecastDays = weather?.forecast.forecastday else { return [] }

        let now = Date()
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: now)

        var items: [(time: String, temp: Int, iconName: String, rainChance: String)] = []

        for (dayIndex, forecastDay) in forecastDays.prefix(2).enumerated() {
            for hour in forecastDay.hour {
                // Parse the hour from the time string (e.g., "2024-01-15 14:00")
                let components = hour.time.split(separator: " ")
                guard components.count == 2,
                      let hourStr = components.last,
                      let hourValue = Int(hourStr.prefix(2)) else {
                    continue
                }

                // Only include future hours for today
                if dayIndex == 0 && hourValue <= currentHour {
                    continue
                }

                // Format the time label
                let timeLabel: String
                if dayIndex == 0 && hourValue == currentHour + 1 {
                    timeLabel = "Now"
                } else {
                    let period = hourValue >= 12 ? "PM" : "AM"
                    let displayHour = hourValue == 0 ? 12 : (hourValue > 12 ? hourValue - 12 : hourValue)
                    timeLabel = "\(displayHour) \(period)"
                }

                let isDay = hour.isDay == 1
                let iconName = WeatherIconMapper.iconName(for: hour.condition.text, isDay: isDay)
                let rainChance = hour.chanceOfRain ?? "0"

                items.append((
                    time: timeLabel,
                    temp: Int(hour.tempC.rounded()),
                    iconName: iconName,
                    rainChance: "\(rainChance)%"
                ))
            }
        }

        return Array(items.prefix(24))
    }

    /// Weekly forecast data for each forecast day.
    var weeklyForecast: [(day: String, temp: Int, iconName: String, rainChance: String, low: Int)] {
        guard let forecastDays = weather?.forecast.forecastday else { return [] }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let dayNameFormatter = DateFormatter()
        dayNameFormatter.dateFormat = "EEE"

        var items: [(day: String, temp: Int, iconName: String, rainChance: String, low: Int)] = []

        for (index, forecastDay) in forecastDays.enumerated() {
            let dayName: String
            if index == 0 {
                dayName = "Today"
            } else if let date = dateFormatter.date(from: forecastDay.date) {
                dayName = dayNameFormatter.string(from: date).uppercased()
            } else {
                dayName = "Day \(index + 1)"
            }

            let iconName = WeatherIconMapper.iconName(for: forecastDay.day.condition.text, isDay: true)
            let rainChance = forecastDay.day.dailyChanceOfRain ?? "0"

            items.append((
                day: dayName,
                temp: Int(forecastDay.day.maxtempC.rounded()),
                iconName: iconName,
                rainChance: "\(rainChance)%",
                low: Int(forecastDay.day.mintempC.rounded())
            ))
        }

        return items
    }

    // MARK: - Data Loading

    /// Loads weather data for the given city name.
    func loadWeather(for city: String) {
        currentCity = city
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let response = try await WeatherService.shared.fetchWeather(for: city)
                await MainActor.run {
                    self.weather = response
                    self.currentCity = response.location.name
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }

    /// Loads weather for the device's current location.
    func loadWeatherForCurrentLocation() {
        hasRequestedLocation = true
        isLoading = true
        errorMessage = nil
        
        let status = locationManager.authorizationStatus
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.requestLocation()
        } else {
            // Fallback if denied or restricted
            loadWeather(for: currentCity)
        }
    }

    // MARK: - CLLocationManagerDelegate

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard hasRequestedLocation else { return }
        
        let status = manager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.requestLocation()
        } else if status == .denied || status == .restricted {
            loadWeather(for: currentCity)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let response = try await WeatherService.shared.fetchWeather(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )
                await MainActor.run {
                    self.weather = response
                    self.currentCity = response.location.name
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // If location fails, fall back to default city
        if hasRequestedLocation {
            loadWeather(for: currentCity)
        }
    }
}
