//
//  SavedLocationsScreen.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI
import SwiftData

struct SavedLocationsScreen: View {

    @Bindable var viewModel: SavedLocationsViewModel

    @Environment(\.modelContext) private var modelContext

    @State private var showDeleteAlert = false
    @State private var locationToDelete: UUID?

    var onLocationSelected: (String) -> Void

    var onDismiss: () -> Void

    var body: some View {
        ZStack {
            WeatherGradients.darkBackground
                .ignoresSafeArea()

            VStack(spacing: 16) {
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

                    Color.clear
                        .frame(width: 80, height: 1)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)

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

                ScrollView {
                    LocationsListView(
                        locations: viewModel.locationWeatherData,
                        isLoading: viewModel.isLoadingLocations,
                        onLocationTap: { location in
                            onLocationSelected(location.cityName)
                        },
                        onDelete: { id in
                            locationToDelete = id
                            showDeleteAlert = true
                        }
                    )
                    .padding(.top, 8)
                }
            }
        }
        .alert("Delete Location", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let id = locationToDelete {
                    viewModel.deleteLocationById(id, context: modelContext)
                    locationToDelete = nil
                }
            }
        } message: {
            Text("Are you sure you want to delete this location?")
        }
        .onAppear {
            viewModel.fetchWeatherForSavedLocations(context: modelContext)
        }
    }
}

#Preview {
    SavedLocationsScreen(
        viewModel: SavedLocationsViewModel(),
        onLocationSelected: { _ in },
        onDismiss: {}
    )
}
