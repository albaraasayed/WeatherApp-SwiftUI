//
//  SearchService.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import Foundation

struct SearchResult: Codable, Identifiable {
    let id: Int
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double

    var displayName: String {
        return "\(name), \(country)"
    }
}

class SearchService {

    static let shared = SearchService()

    private init() {}

    func searchLocations(query: String) async throws -> [SearchResult] {
        guard query.count >= 2 else {
            return []
        }

        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "\(baseUrl)search.json?key=\(apiKey)&q=\(encodedQuery)"

        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(from: url)
        } catch {
            throw WeatherError.networkError(error)
        }

        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode != 200 {
            throw WeatherError.serverError(httpResponse.statusCode)
        }

        do {
            let decoder = JSONDecoder()
            let results = try decoder.decode([SearchResult].self, from: data)
            return results
        } catch {
            throw WeatherError.decodingError(error)
        }
    }
}
