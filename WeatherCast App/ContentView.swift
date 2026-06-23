//
//  ContentView.swift
//  WeatherCast App
//
//  Created by albaraa alsayed on 26/12/1447 AH.
//

import SwiftUI

struct ContentView: View {

    @State private var showLocations = false

    @State private var weatherViewModel = WeatherViewModel()

    @State private var locationsViewModel = SavedLocationsViewModel()

    var body: some View {
        ZStack {
            if showLocations {
                SavedLocationsScreen(
                    viewModel: locationsViewModel,
                    onLocationSelected: { cityName in
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

#Preview {
    ContentView()
}
