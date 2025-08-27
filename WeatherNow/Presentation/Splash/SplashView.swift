// SplashView.swift
// WeatherNow
// Created by Vino_Swify on 26/08/25.
//
// MARK: - Disabled
// This view is currently unused in the app flow.
// Kept for potential future use (intro animation/splash screen).
/*
import SwiftUI
struct SplashView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var pulse = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.blue.opacity(0.25), Color.blue.opacity(0.6)],
                           startPoint: .topLeading, endPoint: .bottomTrailing)

            VStack(spacing: 16) {
                Image(systemName: "cloud.sun.fill")
                    .font(.system(size: 96))
                    .scaleEffect(pulse ? 1.0 : 0.92)
                    .opacity(pulse ? 1.0 : 0.85)
                    .onAppear {
                        guard !reduceMotion else { return }
                        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                            pulse = true
                        }
                    }

                Text("Stay tuned — weather in your city")
                    .font(.headline)
                ProgressView()
            }
            .padding(.horizontal, 32)
        }
        .ignoresSafeArea()
    }
}
*/ 
