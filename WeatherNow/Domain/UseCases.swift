//
//  UseCases.swift
//  WeatherNow
//
//  Created by Vino_Swify on 25/08/25.
//
import Foundation

public struct FetchCurrentWeather {
    let repo: WeatherRepository
    public init(repo: WeatherRepository) { self.repo = repo }
    public func callAsFunction(lat: Double, lon: Double) async throws -> Weather {
        try await repo.current(lat: lat, lon: lon)
    }
}

public struct FetchForecast {
    let repo: WeatherRepository
    public init(repo: WeatherRepository) { self.repo = repo }
    public func callAsFunction(lat: Double, lon: Double) async throws -> [ForecastDay] {
        try await repo.forecast(lat: lat, lon: lon)
    }
}

public struct SearchCity {
    let repo: WeatherRepository
    public init(repo: WeatherRepository) { self.repo = repo }
    public func callAsFunction(_ query: String) async throws -> [GeoCity] {
        try await repo.searchCities(query: query)
    }
}
