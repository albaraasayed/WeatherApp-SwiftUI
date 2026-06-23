//
//  WeatherIconMapper.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import Foundation

// MARK: - Weather Icon Mapper

/// Maps WeatherAPI condition text to local custom 3D asset names.
/// Falls back to SF Symbols when custom assets are not available.
struct WeatherIconMapper {

    // MARK: - Asset Name Constants

    /// All available custom 3D weather icon asset names.
    struct AssetNames {
        static let sun = "Sun"
        static let moon = "Moon"
        static let cloudySun = "Sun_cloud"
        static let cloudyMoon = "Moon_cloud"
        static let sunCloudMidRain = "Sun_cloud_mid_rain"
        static let moonCloudMidRain = "Moon_cloud_mid_rain"
        static let sunCloudAngledRain = "Sun_cloud_angled_rain"
        static let sunCloudRain = "Sun_cloud_rain"
        static let moonCloudFastWind = "Moon_cloud_fast_wind"
        static let cloud = "Cloud"
        static let wind = "Wind"
        static let snow = "Snow"
        static let thunder = "Thunder"
        static let tornado = "Big_Tornado"
        static let fog = "Fog"
        static let drizzle = "Drizzle"
        static let heavyRain = "Heavy_Rain"
        static let sleet = "Sleet"
        static let hail = "Hail"
    }

    // MARK: - SF Symbol Fallbacks

    /// Fallback SF Symbol names for each custom icon.
    private static let sfSymbolFallbacks: [String: String] = [
        AssetNames.sun: "sun.max.fill",
        AssetNames.moon: "moon.fill",
        AssetNames.cloudySun: "cloud.sun.fill",
        AssetNames.cloudyMoon: "cloud.moon.fill",
        AssetNames.sunCloudMidRain: "cloud.sun.rain.fill",
        AssetNames.moonCloudMidRain: "cloud.moon.rain.fill",
        AssetNames.sunCloudAngledRain: "cloud.sun.rain.fill",
        AssetNames.sunCloudRain: "cloud.rain.fill",
        AssetNames.moonCloudFastWind: "cloud.moon.fill",
        AssetNames.cloud: "cloud.fill",
        AssetNames.wind: "wind",
        AssetNames.snow: "snowflake",
        AssetNames.thunder: "cloud.bolt.fill",
        AssetNames.tornado: "tornado",
        AssetNames.fog: "cloud.fog.fill",
        AssetNames.drizzle: "cloud.drizzle.fill",
        AssetNames.heavyRain: "cloud.heavyrain.fill",
        AssetNames.sleet: "cloud.sleet.fill",
        AssetNames.hail: "cloud.hail.fill"
    ]

    // MARK: - Condition to Icon Mapping

    /// Returns the local asset name for a given WeatherAPI condition text.
    /// - Parameters:
    ///   - conditionText: The `condition.text` from the WeatherAPI response.
    ///   - isDay: Whether it's daytime (1) or nighttime (0).
    /// - Returns: The name of the local image asset.
    static func iconName(for conditionText: String, isDay: Bool = true) -> String {
        let condition = conditionText.lowercased()

        // Tornado / Extreme
        if condition.contains("tornado") || condition.contains("hurricane") {
            return AssetNames.tornado
        }

        // Thunder / Storm
        if condition.contains("thunder") || condition.contains("lightning") {
            return AssetNames.thunder
        }

        // Snow / Blizzard / Ice
        if condition.contains("snow") || condition.contains("blizzard") || condition.contains("ice pellets") {
            return AssetNames.snow
        }

        // Sleet
        if condition.contains("sleet") {
            return AssetNames.sleet
        }

        // Hail
        if condition.contains("hail") {
            return AssetNames.hail
        }

        // Heavy rain
        if condition.contains("heavy rain") || condition.contains("torrential") {
            return AssetNames.heavyRain
        }

        // Moderate / Light rain
        if condition.contains("moderate rain") || condition.contains("patchy rain") {
            return isDay ? AssetNames.sunCloudAngledRain : AssetNames.moonCloudMidRain
        }

        // Light rain / drizzle
        if condition.contains("light rain") || condition.contains("light drizzle") || condition.contains("patchy light drizzle") {
            return isDay ? AssetNames.sunCloudMidRain : AssetNames.moonCloudMidRain
        }

        // Drizzle (general)
        if condition.contains("drizzle") {
            return AssetNames.drizzle
        }

        // Rain (general fallback)
        if condition.contains("rain") {
            return isDay ? AssetNames.sunCloudRain : AssetNames.moonCloudMidRain
        }

        // Fog / Mist / Haze
        if condition.contains("fog") || condition.contains("mist") || condition.contains("haze") {
            return AssetNames.fog
        }

        // Wind
        if condition.contains("wind") || condition.contains("gale") || condition.contains("squall") {
            return isDay ? AssetNames.wind : AssetNames.moonCloudFastWind
        }

        // Overcast
        if condition.contains("overcast") {
            return AssetNames.cloud
        }

        // Partly cloudy / Cloudy
        if condition.contains("partly cloudy") || condition.contains("partly") {
            return isDay ? AssetNames.cloudySun : AssetNames.cloudyMoon
        }

        if condition.contains("cloudy") || condition.contains("cloud") {
            return AssetNames.cloud
        }

        // Clear / Sunny
        if condition.contains("clear") || condition.contains("sunny") {
            return isDay ? AssetNames.sun : AssetNames.moon
        }

        // Default fallback
        return isDay ? AssetNames.sun : AssetNames.moon
    }

    /// Returns the SF Symbol fallback name for a given asset name.
    /// Use this when the custom image asset is not available.
    static func sfSymbolName(for assetName: String) -> String {
        return sfSymbolFallbacks[assetName] ?? "cloud.fill"
    }
}
