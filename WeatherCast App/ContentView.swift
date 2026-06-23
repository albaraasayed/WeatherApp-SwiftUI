//
//  ContentView.swift
//  WeatherCast App
//
//  Created by albaraa alsayed on 26/12/1447 AH.
//

import SwiftUI

// MARK: - Content View

/// Root view that manages navigation between the Home Weather screen
/// and the Saved Locations screen.
struct ContentView: View {

    // MARK: - State

    /// Controls which screen is currently showing
    @State private var showLocations = false

    /// The shared WeatherViewModel
    @State private var weatherViewModel = WeatherViewModel()

    /// The shared SavedLocationsViewModel
    @State private var locationsViewModel = SavedLocationsViewModel()

    // MARK: - Body

    var body: some View {
        ZStack {
            if showLocations {
                // Saved Locations Screen
                SavedLocationsScreen(
                    viewModel: locationsViewModel,
                    onLocationSelected: { cityName in
                        // Load weather for the selected city, then switch to home
                        weatherViewModel.loadWeather(for: cityName)
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showLocations = false
                        }
                    },
                    onDismiss: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showLocations = false
                        }
                    }
                )
                .transition(.move(edge: .trailing))
            } else {
                // Home Weather Screen
                HomeWeatherScreen(
                    viewModel: weatherViewModel,
                    onShowLocations: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showLocations = true
                        }
                    }
                )
                .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showLocations)
        .preferredColorScheme(.dark)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
