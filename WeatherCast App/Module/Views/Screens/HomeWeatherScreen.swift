//
//  HomeWeatherScreen.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

struct HomeWeatherScreen: View {

    var viewModel: WeatherViewModel

    var onShowLocations: () -> Void

    @State private var sheetOffset: CGFloat = 500
    @State private var lastDragOffset: CGFloat = 500
    @State private var hasInitializedOffset = false

    var body: some View {
        GeometryReader { proxy in
            let minOffset: CGFloat = proxy.safeAreaInsets.top + 180
            
            let maxOffset: CGFloat = proxy.size.height - 180

            ZStack(alignment: .top) {
                
                Image(viewModel.isDay ? "light-background" : "night-background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: 0) {
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
                            viewModel.requestLocationManually()
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

                    HeaderView(
                        cityName: viewModel.currentCity,
                        temperature: viewModel.currentTemperature,
                        condition: viewModel.conditionText,
                        highTemp: viewModel.highTemperature,
                        lowTemp: viewModel.lowTemperature,
                        isDay: viewModel.isDay
                    )
                    .padding(.top, 8)

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
                .frame(height: proxy.size.height - minOffset + proxy.safeAreaInsets.bottom + 100)
                .ignoresSafeArea(.all, edges: .bottom)
                .offset(y: sheetOffset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            let newOffset = lastDragOffset + gesture.translation.height
                            sheetOffset = min(max(newOffset, minOffset), maxOffset)
                        }
                        .onEnded { gesture in
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                if gesture.translation.height < -50 {
                                    sheetOffset = minOffset
                                } else if gesture.translation.height > 50 {
                                    sheetOffset = maxOffset
                                } else {
                                    let distanceToMin = abs(sheetOffset - minOffset)
                                    let distanceToMax = abs(sheetOffset - maxOffset)
                                    sheetOffset = distanceToMin < distanceToMax ? minOffset : maxOffset
                                }
                            }
                            lastDragOffset = sheetOffset
                        }
                )

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
                    viewModel.loadWeatherForCurrentLocation()
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
        .alert("Location Access Denied", isPresented: .init(
            get: { viewModel.showSettingsAlert },
            set: { viewModel.showSettingsAlert = $0 }
        )) {
            Button("Cancel", role: .cancel) {}
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
        } message: {
            Text("Please enable location access in Settings to fetch local weather.")
        }
    }
}

#Preview {
    HomeWeatherScreen(
        viewModel: WeatherViewModel(),
        onShowLocations: {}
    )
}
