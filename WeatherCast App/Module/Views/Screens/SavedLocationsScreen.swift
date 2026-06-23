//
//  SavedLocationsScreen.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI
import SwiftData

// MARK: - Saved Locations Screen

/// The screen where users can search for cities, save them, view saved locations,
/// and tap a location to navigate to its weather.
struct SavedLocationsScreen: View {

    // MARK: - Properties

    /// The ViewModel for search and saved locations management
    @Bindable var viewModel: SavedLocationsViewModel

    /// SwiftData model context for persistence
    @Environment(\.modelContext) private var modelContext

    /// Called when a location is tapped (to navigate to its weather)
    var onLocationSelected: (String) -> Void

    /// Called when the back button is tapped
    var onDismiss: () -> Void

    // MARK: - Body

    var body: some View {
        ZStack {
            // Background
            WeatherGradients.darkBackground
                .ignoresSafeArea()

            VStack(spacing: 16) {
                // Top toolbar
                HStack {
                    Button {
                        onDismiss()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Weather")
                                .font(.system(size: 16))
                        }
                        .foregroundStyle(.white)
                    }

                    Spacer()

                    Text("Saved Locations")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)

                    Spacer()

                    // Invisible spacer to center title
                    Color.clear
                        .frame(width: 80, height: 1)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)

                // Search bar
                SearchBarView(
                    searchText: $viewModel.searchText,
                    onSearch: {
                        viewModel.searchLocations()
                    },
                    onClear: {
                        viewModel.searchResults = []
                    }
                )
                .padding(.horizontal, 16)

                // Search results dropdown (shown when searching)
                if !viewModel.searchResults.isEmpty {
                    VStack(spacing: 0) {
                        ForEach(viewModel.searchResults) { result in
                            SearchResultRow(
                                cityName: result.name,
                                country: result.country,
                                onAdd: {
                                    viewModel.saveLocation(from: result, context: modelContext)
                                }
                            )

                            if result.id != viewModel.searchResults.last?.id {
                                Divider()
                                    .background(Color.white.opacity(0.1))
                            }
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(hex: "2E335A").opacity(0.5))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 16)
                }

                // Searching indicator
                if viewModel.isSearching {
                    VStack {
                        Spacer()
                        HStack(spacing: 8) {
                            ProgressView()
                                .tint(.white)
                                .scaleEffect(0.8)
                            Text("Searching...")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.themeSecondary.opacity(0.5))
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                // Saved locations list
                ScrollView {
                    LocationsListView(
                        locations: viewModel.locationWeatherData,
                        isLoading: viewModel.isLoadingLocations,
                        onLocationTap: { location in
                            onLocationSelected(location.cityName)
                        },
                        onDelete: { id in
                            viewModel.deleteLocationById(id, context: modelContext)
                        }
                    )
                    .padding(.top, 8)
                }
            }
        }
        .onAppear {
            viewModel.fetchWeatherForSavedLocations(context: modelContext)
        }
    }
}

// MARK: - Preview

#Preview {
    SavedLocationsScreen(
        viewModel: SavedLocationsViewModel(),
        onLocationSelected: { _ in },
        onDismiss: {}
    )
}
