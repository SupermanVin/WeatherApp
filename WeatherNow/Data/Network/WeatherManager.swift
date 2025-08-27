//  OpenWeatherAPI.swift
//  Created by Vino_Swify on 25/08/25.

import Foundation

final class WeatherManager {
    static let shared = WeatherManager()
    private init() {}

    func getCurrent(lat: Double, lon: Double) async throws -> CurrentDTO {
        try await NetworkManager.shared.send(WeatherAPI.current(lat: lat, lon: lon))
    }

    func getForecast(lat: Double, lon: Double) async throws -> ForecastDTO {
        try await NetworkManager.shared.send(WeatherAPI.forecast(lat: lat, lon: lon))
    }

    func geocode(_ query: String) async throws -> [GeoDTO] {
        try await NetworkManager.shared.send(WeatherAPI.geocode(query: query))
    }
}
