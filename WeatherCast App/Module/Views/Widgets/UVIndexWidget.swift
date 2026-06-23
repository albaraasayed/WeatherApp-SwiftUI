//
//  UVIndexWidget.swift
//  WeatherCast App
//
//  Created by albaraa alsayed.
//

import SwiftUI

struct UVIndexWidget: View {

    let uvValue: Double

    let description: String

    private var progress: Double {
        return min(uvValue / 11.0, 1.0)
    }

    private var uvColor: Color {
        if uvValue <= 2 { return Color(hex: "34C759") }
        if uvValue <= 5 { return Color(hex: "FFD60A") }
        if uvValue <= 7 { return Color(hex: "FF9F0A") }
        if uvValue <= 10 { return Color(hex: "FF3B30") }
        return Color(hex: "8B0000")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.themeSecondary.opacity(0.6))

                Text("UV INDEX")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.themeSecondary.opacity(0.6))
                    .tracking(0.5)
            }

            Text("\(Int(uvValue))")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)

            Text(description)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)

            Spacer()

            ZStack {
                Circle()
                    .trim(from: 0, to: 0.5)
                    .stroke(Color.white.opacity(0.15), lineWidth: 6)
                    .rotationEffect(.degrees(180))

                Circle()
                    .trim(from: 0, to: progress * 0.5)
                    .stroke(
                        uvColor,
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .rotationEffect(.degrees(180))

                Circle()
                    .fill(uvColor)
                    .frame(width: 10, height: 10)
                    .shadow(color: uvColor.opacity(0.6), radius: 4)
                    .offset(
                        x: cos(.pi + progress * .pi) * 35,
                        y: sin(.pi + progress * .pi) * 35
                    )
            }
            .frame(width: 80, height: 40)
            .frame(maxWidth: .infinity)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 180)
        .glassmorphic(cornerRadius: 22)
    }
}

#Preview {
    ZStack {
        WeatherGradients.darkBackground
            .ignoresSafeArea()

        HStack(spacing: 12) {
            UVIndexWidget(uvValue: 4, description: "Moderate")
            UVIndexWidget(uvValue: 9, description: "Very High")
        }
        .padding()
    }
}
