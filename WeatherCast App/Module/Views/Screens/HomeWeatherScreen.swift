//
//  HomeWeatherScreen.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

// MARK: - Home Weather Screen

/// The main weather screen that composes the Header, central weather artwork,
/// and the Forecast Bottom Sheet. Acts purely as a container for sub-components.
struct HomeWeatherScreen: View {

    // MARK: - Properties

    /// The ViewModel that provides all weather data
    var viewModel: WeatherViewModel

    /// Called when the user taps the location list button
    var onShowLocations: () -> Void

    // MARK: - State

    @State private var sheetOffset: CGFloat = 400
    @State private var lastDragOffset: CGFloat = 400
    private let sheetMinOffset: CGFloat = 250
    private let sheetMaxOffset: CGFloat = 500

    // MARK: - Body

    var body: some View {
        ZStack {
            // Full-screen gradient background
            WeatherGradients.darkBackground
                .ignoresSafeArea()

            // Background image
            Image("night-background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(0.4)

            // Main content
            VStack(spacing: 0) {
                // Top toolbar
                HStack {
                    // Location button
                    Button {
                        onShowLocations()
                    } label: {
                        Image(systemName: "list.bullet")
                            .font(.system(size: 20))
                            .foregroundStyle(.white)
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(.ultraThinMaterial.opacity(0.5))
                            )
                    }

                    Spacer()

                    // Current location button
                    Button {
                        viewModel.loadWeatherForCurrentLocation()
                    } label: {
                        Image(systemName: "location.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(.ultraThinMaterial.opacity(0.5))
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)

                // Header: City name, temperature, condition, H/L
                HeaderView(
                    cityName: viewModel.currentCity,
                    temperature: viewModel.currentTemperature,
                    condition: viewModel.conditionText,
                    highTemp: viewModel.highTemperature,
                    lowTemp: viewModel.lowTemperature
                )
                .padding(.top, 8)

                // Central weather artwork
                ZStack {
                    // Radial glow behind artwork
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

                    // Weather icon
                    if let _ = UIImage(named: viewModel.currentIconName) {
                        Image(viewModel.currentIconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180, height: 180)
                    } else {
                        Image(systemName: WeatherIconMapper.sfSymbolName(for: viewModel.currentIconName))
                            .font(.system(size: 80))
                            .symbolRenderingMode(.multicolor)
                    }
                }
                .frame(height: 200)

                Spacer()
            }

            // Bottom sheet overlay
            VStack {
                Spacer()

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
                .frame(height: UIScreen.main.bounds.height * 0.55)
                .offset(y: sheetOffset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            let newOffset = lastDragOffset + gesture.translation.height
                            sheetOffset = min(max(newOffset, sheetMinOffset), sheetMaxOffset)
                        }
                        .onEnded { gesture in
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                if gesture.translation.height < -50 {
                                    // Swipe up — expand
                                    sheetOffset = sheetMinOffset
                                } else {
                                    // Swipe down — collapse
                                    sheetOffset = sheetMaxOffset
                                }
                            }
                            lastDragOffset = sheetOffset
                        }
                )
            }
            .ignoresSafeArea(edges: .bottom)

            // Loading overlay
            if viewModel.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()

                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
            }
        }
        .onAppear {
            if viewModel.weather == nil {
                viewModel.loadWeather(for: viewModel.currentCity)
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
