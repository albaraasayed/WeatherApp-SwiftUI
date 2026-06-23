//
//  HomeWeatherScreen.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

// MARK: - Home Weather Screen

/// The main weather screen that composes the Header, central weather artwork,
/// the house parallax layer, and the Forecast Bottom Sheet.
struct HomeWeatherScreen: View {

    // MARK: - Properties

    /// The ViewModel that provides all weather data
    var viewModel: WeatherViewModel

    /// Called when the user taps the location list button
    var onShowLocations: () -> Void

    // MARK: - State

    @State private var sheetOffset: CGFloat = 500
    @State private var lastDragOffset: CGFloat = 500
    @State private var hasInitializedOffset = false

    // MARK: - Body

    var body: some View {
        GeometryReader { proxy in
            // Calculate dynamic bounds based on screen size.
            // 180 pts roughly covers the top toolbar, city name, large temperature, condition, and H: L: texts.
            // This snaps the slider exactly underneath the High/Low temperature text.
            let minOffset: CGFloat = proxy.safeAreaInsets.top + 180
            
            // Leave a portion of the slider visible at the bottom of the screen.
            let maxOffset: CGFloat = proxy.size.height - 180

            ZStack(alignment: .top) {
                
                // 1. Background Layer (Bottom-most Z-Index)
                Image(viewModel.isDay ? "light-background" : "night-background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                // Static Content Layer (Toolbar, Header, Artwork)
                VStack(spacing: 0) {
                    // Top toolbar
                    HStack {
                        Button {
                            onShowLocations()
                        } label: {
                            Image(systemName: "list.bullet")
                                .font(.system(size: 20))
                                .foregroundStyle(.white)
                                .padding(10)
                                .background(Circle().fill(.ultraThinMaterial.opacity(0.5)))
                        }

                        Spacer()

                        Button {
                            viewModel.loadWeatherForCurrentLocation()
                        } label: {
                            Image(systemName: "location.fill")
                                .font(.system(size: 16))
                                .foregroundStyle(.white)
                                .padding(10)
                                .background(Circle().fill(.ultraThinMaterial.opacity(0.5)))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, proxy.safeAreaInsets.top + 8)

                    // Header: City name, temperature, condition, H/L
                    HeaderView(
                        cityName: viewModel.currentCity,
                        temperature: viewModel.currentTemperature,
                        condition: viewModel.conditionText,
                        highTemp: viewModel.highTemperature,
                        lowTemp: viewModel.lowTemperature,
                        isDay: viewModel.isDay
                    )
                    .padding(.top, 8)

                    // Central weather artwork
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color(hex: "F7CBFD").opacity(0.15),
                                        Color(hex: "7758D1").opacity(0.05),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: 10,
                                    endRadius: 140
                                )
                            )
                            .frame(width: 280, height: 280)

                        Image(viewModel.currentIconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180, height: 180)
                    }
                    .frame(height: 200)

                    Spacer()
                }

                // 2. Top Layer: Forecast Bottom Sheet (Slider)
                ForecastBottomSheet(
                    hourlyData: viewModel.hourlyForecast,
                    weeklyData: viewModel.weeklyForecast,
                    uvIndex: viewModel.uvIndex,
                    uvDescription: viewModel.uvDescription,
                    sunrise: viewModel.sunriseTime,
                    sunset: viewModel.sunsetTime,
                    windSpeed: viewModel.windSpeed,
                    windDirection: viewModel.windDirection,
                    rainfall: viewModel.rainfall,
                    feelsLike: viewModel.feelsLike,
                    actualTemp: viewModel.currentTemperature,
                    humidity: viewModel.humidity,
                    visibility: viewModel.visibility,
                    pressure: viewModel.pressure,
                    airQualityIndex: viewModel.airQualityIndex,
                    airQualityDescription: viewModel.airQualityDescription
                )
                // Height covers the remaining screen down to the bottom when fully expanded.
                // Added extra padding to ensure the bottom rounded corners are hidden off-screen.
                .frame(height: proxy.size.height - minOffset + proxy.safeAreaInsets.bottom + 100)
                .ignoresSafeArea(.all, edges: .bottom)
                .offset(y: sheetOffset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            let newOffset = lastDragOffset + gesture.translation.height
                            // Clamp the offset within min and max bounds
                            sheetOffset = min(max(newOffset, minOffset), maxOffset)
                        }
                        .onEnded { gesture in
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                if gesture.translation.height < -50 {
                                    // Snapped to Top (minOffset)
                                    sheetOffset = minOffset
                                } else if gesture.translation.height > 50 {
                                    // Snapped to Bottom (maxOffset)
                                    sheetOffset = maxOffset
                                } else {
                                    // Snap to nearest
                                    let distanceToMin = abs(sheetOffset - minOffset)
                                    let distanceToMax = abs(sheetOffset - maxOffset)
                                    sheetOffset = distanceToMin < distanceToMax ? minOffset : maxOffset
                                }
                            }
                            lastDragOffset = sheetOffset
                        }
                )

                // Loading overlay
                if viewModel.isLoading {
                    ZStack {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()

                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.5)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .ignoresSafeArea()
            .onAppear {
                if !hasInitializedOffset {
                    sheetOffset = maxOffset
                    lastDragOffset = maxOffset
                    hasInitializedOffset = true
                }
                if viewModel.weather == nil {
                    viewModel.loadWeather(for: viewModel.currentCity)
                }
            }
        }
        .alert("Error", isPresented: .init(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("Retry") {
                viewModel.loadWeather(for: viewModel.currentCity)
            }
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "An unknown error occurred.")
        }
    }
}

// MARK: - Preview

#Preview {
    HomeWeatherScreen(
        viewModel: WeatherViewModel(),
        onShowLocations: {}
    )
}
