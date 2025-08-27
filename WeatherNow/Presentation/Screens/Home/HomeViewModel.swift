//  HomeViewModel.swift
//  WeatherNow
//  Created by Vino_Swify on 25/08/25.

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    // MARK: - Screen State
    /// Represents the different loading states of HomeView
    enum State: Equatable {
        case idle         // Nothing loaded yet
        case loading      // Actively fetching data
        case loaded(weather: Weather, forecast: [ForecastDay]) // Success
        case error(String) // Error message to display
    }
    
    // Published state → drives the UI
    @Published var state: State = .idle
    
    // Data dependency (WeatherRepository handles networking)
    private let repo: WeatherRepository
    
    // Default repo = live WeatherRepositoryImpl
    init(repo: WeatherRepository = WeatherRepositoryImpl()) {
        self.repo = repo
    }
    
    /// Loads both current weather + forecast for given coordinates
    func load(lat: Double, lon: Double) async {
        // Show spinner in UI
        state = .loading
        do {
            // Run current weather + forecast in parallel
            async let w = repo.current(lat: lat, lon: lon)
            async let f = repo.forecast(lat: lat, lon: lon)
            
            // Wait for both results
            let (weather, forecast) = try await (w, f)
            
            // Update UI with loaded data
            state = .loaded(weather: weather, forecast: forecast)
        } catch {
            // Show user-friendly error message if fetch fails
            state = .error("Couldn’t load weather. Check your network/API key.")
        }
    }
}
