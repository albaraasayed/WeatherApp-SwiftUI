//
//  SearchResultRow.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

// MARK: - Search Result Row

/// A single row in the search results dropdown showing the city name,
/// region/country, and an add button.
struct SearchResultRow: View {

    // MARK: - Properties

    /// The city name (e.g., "Montreal")
    let cityName: String

    /// The country name (e.g., "Canada")
    let country: String

    /// Called when the user taps to add this location
    var onAdd: () -> Void

    // MARK: - Body

    var body: some View {
        HStack {
            // City and country info
            VStack(alignment: .leading, spacing: 2) {
                Text(cityName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)

                Text(country)
                    .font(.system(size: 13))
                    .foregroundStyle(Color.themeSecondary.opacity(0.5))
            }

            Spacer()

            // Add button
            Button {
                onAdd()
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(Color(hex: "48319D"))
                    .background(
                        Circle()
                            .fill(.white)
                            .frame(width: 22, height: 22)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        WeatherGradients.darkBackground
            .ignoresSafeArea()

        VStack(spacing: 0) {
            SearchResultRow(
                cityName: "Montreal",
                country: "Canada",
                onAdd: {}
            )
            Divider()
                .background(Color.white.opacity(0.1))
            SearchResultRow(
                cityName: "Moscow",
                country: "Russia",
                onAdd: {}
            )
            Divider()
                .background(Color.white.opacity(0.1))
            SearchResultRow(
                cityName: "Monaco",
                country: "Monaco",
                onAdd: {}
            )
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
        .padding()
    }
}
