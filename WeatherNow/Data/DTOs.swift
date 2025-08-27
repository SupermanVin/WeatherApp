//  DTOs.swift
//  Created by Vino_Swify on 25/08/25.
import Foundation

// Current
struct CurrentDTO: Decodable {
    struct Main: Decodable { let temp: Double; let feels_like: Double; let humidity: Int }
    struct WeatherDesc: Decodable { let main: String; let description: String }
    struct Wind: Decodable { let speed: Double }
    let name: String
    let main: Main
    let weather: [WeatherDesc]
    let wind: Wind
}

// Forecast
struct ForecastDTO: Decodable {
    struct Item: Decodable {
        let dt: TimeInterval
        let main: CurrentDTO.Main
        let weather: [CurrentDTO.WeatherDesc]
    }
    let list: [Item]
}

// Geocoding
struct GeoDTO: Decodable { let name: String; let country: String; let lat: Double; let lon: Double }
