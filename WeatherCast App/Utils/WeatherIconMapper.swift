//
//  WeatherIconMapper.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import Foundation

struct WeatherIconMapper {

    static func iconName(for conditionText: String, isDay: Bool = true) -> String {
        let condition = conditionText.lowercased()

        if condition.contains("tornado") || condition.contains("hurricane") {
            return "Big_Tornado"
        }

        if condition.contains("heavy rain") || condition.contains("torrential") {
            return isDay ? "Sun cloud angled rain" : "Moon cloud mid rain"
        }

        if condition.contains("rain") || condition.contains("drizzle") || condition.contains("sleet") || condition.contains("snow") || condition.contains("hail") || condition.contains("ice") {
            return isDay ? "Sun cloud mid rain" : "Moon cloud mid rain"
        }

        if condition.contains("wind") || condition.contains("gale") || condition.contains("squall") || condition.contains("fast wind") {
            return "Moon cloud fast wind"
        }

        return isDay ? "Sun cloud mid rain" : "Moon cloud fast wind"
    }
}
