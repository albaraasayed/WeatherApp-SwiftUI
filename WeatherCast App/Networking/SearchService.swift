//
//  SearchService.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import Foundation

// MARK: - Search Result Model

/// Represents a single city result from the WeatherAPI search endpoint.
struct SearchResult: Codable, Identifiable {
    let id: Int
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double

    /// A formatted display string: "City, Country"
    var displayName: String {
        return "\(name), \(country)"
    }
}

// MARK: - Search Service

/// Handles location search requests using the WeatherAPI `search.json` endpoint.
class SearchService {

    /// Shared singleton instance
    static let shared = SearchService()

    private init() {}

    /// Searches for locations matching the given query string.
    /// - Parameter query: The search text (city name, postal code, etc.)
    /// - Returns: An array of `SearchResult` matching the query.
    func searchLocations(query: String) async throws -> [SearchResult] {
        // Don't search for very short queries
        guard query.count >= 2 else {
            return []
        }

        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "\(baseUrl)search.json?key=\(apiKey)&q=\(encodedQuery)"

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

        // Decode the JSON array
        do {
            let decoder = JSONDecoder()
            let results = try decoder.decode([SearchResult].self, from: data)
            return results
        } catch {
            throw WeatherError.decodingError(error)
        }
    }
}
