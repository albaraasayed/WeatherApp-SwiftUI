//
//  WeatherViewModel.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import Foundation
import CoreLocation
import Observation

@Observable
class WeatherViewModel: NSObject, CLLocationManagerDelegate {

    var weather: WeatherResponse?

    var isLoading: Bool = false

    var errorMessage: String?

    var currentCity: String = "Montreal"

    var showSettingsAlert: Bool = false

    private let locationManager = CLLocationManager()
    private var hasRequestedLocation = false

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    var currentTemperature: String {
        guard let temp = weather?.current.tempC else { return "--°" }
        return "\(Int(temp.rounded()))°"
    }

    var conditionText: String {
        return weather?.current.condition.text ?? "Loading..."
    }

    var highTemperature: String {
        guard let day = weather?.forecast.forecastday.first?.day else { return "H:--°" }
        return "H:\(Int(day.maxtempC.rounded()))°"
    }

    var lowTemperature: String {
        guard let day = weather?.forecast.forecastday.first?.day else { return "L:--°" }
        return "L:\(Int(day.mintempC.rounded()))°"
    }

    var currentIconName: String {
        guard let weather = weather else { return "Sun" }
        let isDay = weather.current.isDay == 1
        return WeatherIconMapper.iconName(for: weather.current.condition.text, isDay: isDay)
    }

    var isDay: Bool {
        return weather?.current.isDay == 1
    }

    var uvIndex: Double {
        return weather?.current.uv ?? 0
    }

    var uvDescription: String {
        let uv = uvIndex
        if uv <= 2 { return "Low" }
        if uv <= 5 { return "Moderate" }
        if uv <= 7 { return "High" }
        if uv <= 10 { return "Very High" }
        return "Extreme"
    }

    var sunriseTime: String {
        return weather?.forecast.forecastday.first?.astro.sunrise ?? "--:--"
    }

    var sunsetTime: String {
        return weather?.forecast.forecastday.first?.astro.sunset ?? "--:--"
    }

    var windSpeed: Double {
        return weather?.current.windKph ?? 0
    }

    var windDirection: String {
        return weather?.current.windDir ?? "N"
    }

    var rainfall: Double {
        return weather?.current.precipMm ?? 0
    }

    var feelsLike: String {
        guard let feels = weather?.current.feelslikeC else { return "--°" }
        return "\(Int(feels.rounded()))°"
    }

    var humidity: Int {
        return weather?.current.humidity ?? 0
    }

    var visibility: Double {
        return weather?.current.visKm ?? 0
    }

    var pressure: Double {
        return weather?.current.pressureMb ?? 0
    }

    var airQualityIndex: Int {
        return weather?.current.airQuality?.usEpaIndex ?? 1
    }

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

    var hourlyForecast: [(time: String, temp: Int, iconName: String, rainChance: String)] {
        guard let forecastDays = weather?.forecast.forecastday else { return [] }

        let now = Date()
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: now)

        var items: [(time: String, temp: Int, iconName: String, rainChance: String)] = []

        for (dayIndex, forecastDay) in forecastDays.prefix(2).enumerated() {
            for hour in forecastDay.hour {
                let components = hour.time.split(separator: " ")
                guard components.count == 2,
                      let hourStr = components.last,
                      let hourValue = Int(hourStr.prefix(2)) else {
                    continue
                }

                if dayIndex == 0 && hourValue <= currentHour {
                    continue
                }

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
                let rainChance = hour.chanceOfRain ?? 0

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
            let rainChance = forecastDay.day.dailyChanceOfRain ?? 0

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
            loadWeather(for: currentCity)
        }
    }

    func requestLocationManually() {
        hasRequestedLocation = true
        let status = locationManager.authorizationStatus
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            isLoading = true
            errorMessage = nil
            locationManager.requestLocation()
        } else if status == .denied || status == .restricted {
            showSettingsAlert = true
        }
    }

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
        if hasRequestedLocation {
            loadWeather(for: currentCity)
        }
    }
}
