//
//  SearchBarView.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

// MARK: - Search Bar View

/// A glassmorphic search field with a magnifying glass icon.
/// Triggers search when text changes (debounced via onChange).
struct SearchBarView: View {

    // MARK: - Properties

    @Binding var searchText: String

    /// Called when the search text changes (after a brief delay)
    var onSearch: () -> Void

    /// Called when the user taps the clear button
    var onClear: () -> Void

    // MARK: - Body

    var body: some View {
        HStack(spacing: 10) {
            // Magnifying glass icon
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16))
                .foregroundStyle(Color.themeSecondary.opacity(0.5))

            // Text field
            TextField("Search for a city...", text: $searchText)
                .font(.system(size: 16))
                .foregroundStyle(.white)
                .tint(Color(hex: "40CBD8"))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.words)

            // Clear button
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                    onClear()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.themeSecondary.opacity(0.5))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(hex: "2E335A").opacity(0.4))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
        )
        .onChange(of: searchText) { _, _ in
            onSearch()
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        WeatherGradients.darkBackground
            .ignoresSafeArea()

        VStack(spacing: 20) {
            SearchBarView(
                searchText: .constant(""),
                onSearch: {},
                onClear: {}
            )

            SearchBarView(
                searchText: .constant("Montreal"),
                onSearch: {},
                onClear: {}
            )
        }
        .padding()
    }
}
