//
//  WeatherCast_AppApp.swift
//  WeatherCast App
//
//  Created by albaraa alsayed on 26/12/1447 AH.
//

import SwiftUI
import SwiftData

@main
struct WeatherCast_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: SavedLocation.self)
    }
}
