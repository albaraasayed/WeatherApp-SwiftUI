//
//  ForecastTabToggler.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

// MARK: - Forecast Tab

/// The two available forecast tabs.
enum ForecastTab: String, CaseIterable {
    case hourly = "Hourly Forecast"
    case weekly = "Weekly Forecast"
}

// MARK: - Forecast Tab Toggler

/// A segmented control with a glassmorphic background for switching
/// between Hourly and Weekly forecast views.
struct ForecastTabToggler: View {

    // MARK: - Properties

    @Binding var selectedTab: ForecastTab

    // MARK: - Body

    var body: some View {
        HStack(spacing: 0) {
            ForEach(ForecastTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        selectedTab = tab
                    }
                } label: {
                    Text(tab.rawValue)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(
                            selectedTab == tab
                            ? Color.white
                            : Color.themeSecondary.opacity(0.5)
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            Group {
                                if selectedTab == tab {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color(hex: "48319D").opacity(0.6))
                                }
                            }
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
        )
        .padding(.horizontal, 16)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        WeatherGradients.darkBackground
            .ignoresSafeArea()

        ForecastTabToggler(selectedTab: .constant(.hourly))
    }
}
