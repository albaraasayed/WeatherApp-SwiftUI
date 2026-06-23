//
//  WeatherIconMapper.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import Foundation

// MARK: - Weather Icon Mapper

/// Maps WeatherAPI condition text strictly to the custom 3D asset names provided by the user.
struct WeatherIconMapper {

    // MARK: - Condition to Icon Mapping

    /// Returns the exact custom local asset name for a given WeatherAPI condition text.
    /// Uses specified fallback assets for daytime and nighttime when a precise match isn't found.
    /// - Parameters:
    ///   - conditionText: The `condition.text` from the WeatherAPI response.
    ///   - isDay: Whether it's daytime (1) or nighttime (0).
    /// - Returns: The exact name of the local image asset.
    static func iconName(for conditionText: String, isDay: Bool = true) -> String {
        let condition = conditionText.lowercased()

        // Tornado / Hurricane / Extreme
        if condition.contains("tornado") || condition.contains("hurricane") {
            return "Big_Tornado"
        }

        // Heavy Rain / Torrential
        if condition.contains("heavy rain") || condition.contains("torrential") {
            return isDay ? "Sun cloud angled rain" : "Moon cloud mid rain"
        }

        // Rain / Drizzle / Sleet / Snow / Hail
        if condition.contains("rain") || condition.contains("drizzle") || condition.contains("sleet") || condition.contains("snow") || condition.contains("hail") || condition.contains("ice") {
            return isDay ? "Sun cloud mid rain" : "Moon cloud mid rain"
        }

        // Wind / Gale / Squall
        if condition.contains("wind") || condition.contains("gale") || condition.contains("squall") || condition.contains("fast wind") {
            return "Moon cloud fast wind"
        }

        // Default Fallback
        // (Applies to Clear, Sunny, Cloudy, Overcast, Partly Cloudy, Fog, Mist, etc.)
        return isDay ? "Sun cloud mid rain" : "Moon cloud fast wind"
    }
}
