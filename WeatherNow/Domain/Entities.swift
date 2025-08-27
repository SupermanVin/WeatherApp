//
//  Entities.swift
//  WeatherNow
//
//  Created by Vino_Swify on 25/08/25.
//
import Foundation

public struct Weather: Equatable {
    public let city: String
    public let tempC: Double
    public let feelsLikeC: Double
    public let condition: String
    public let humidity: Int
    public let windKph: Double
}

public struct ForecastDay: Equatable, Identifiable {
    public let id = UUID()
    public let date: Date
    public let minC: Double
    public let maxC: Double
    public let symbol: String
}

public struct GeoCity: Equatable, Identifiable {
    public let id = UUID()
    public let name: String
    public let country: String
    public let lat: Double
    public let lon: Double
}
