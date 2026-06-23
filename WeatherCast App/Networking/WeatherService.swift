//
//  WeatherService.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import Foundation

// MARK: - Weather Error

/// Custom errors that can occur during weather data fetching.
enum WeatherError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case noData
    case serverError(Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL. Please check the city name."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to parse weather data: \(error.localizedDescription)"
        case .noData:
            return "No weather data received."
        case .serverError(let code):
            return "Server returned error code: \(code)"
        }
    }
}

// MARK: - Weather Service

/// Handles all network requests to the WeatherAPI `forecast.json` endpoint.
class WeatherService {

    /// Shared singleton instance
    static let shared = WeatherService()

    private init() {}

    /// Fetches the full weather forecast for a given city name.
    /// - Parameter city: The city name to search for (e.g., "Montreal").
    /// - Returns: A decoded `WeatherResponse` with current, forecast, and location data.
    func fetchWeather(for city: String) async throws -> WeatherResponse {
        // Build the URL with query parameters
        let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let urlString = "\(baseUrl)forecast.json?key=\(apiKey)&q=\(encodedCity)&days=7&aqi=yes"

        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }

        // Make the network request
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(from: url)
        } catch {
            throw WeatherError.networkError(error)
        }

        // Check for HTTP errors
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode != 200 {
            throw WeatherError.serverError(httpResponse.statusCode)
        }

        // Decode the JSON response
        do {
            let decoder = JSONDecoder()
            let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
            return weatherResponse
        } catch let error as DecodingError {
            switch error {
            case .typeMismatch(let type, let context):
                print("Type '\(type)' mismatch: \(context.debugDescription)")
                print("codingPath: \(context.codingPath)")
            case .valueNotFound(let value, let context):
                print("Value '\(value)' not found: \(context.debugDescription)")
                print("codingPath: \(context.codingPath)")
            case .keyNotFound(let key, let context):
                print("Key '\(key)' not found: \(context.debugDescription)")
                print("codingPath: \(context.codingPath)")
            case .dataCorrupted(let context):
                print("Data corrupted: \(context)")
            @unknown default:
                print("Unknown decoding error: \(error)")
            }
            throw WeatherError.decodingError(error)
        } catch {
            print("Generic decoding error: \(error)")
            throw WeatherError.decodingError(error)
        }
    }

    /// Fetches weather for a specific latitude/longitude coordinate.
    /// - Parameters:
    ///   - latitude: The latitude value.
    ///   - longitude: The longitude value.
    /// - Returns: A decoded `WeatherResponse`.
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherResponse {
        let query = "\(latitude),\(longitude)"
        return try await fetchWeather(for: query)
    }
}
