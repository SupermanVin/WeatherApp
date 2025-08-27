//  WeatherRepositoryImpl.swift
//  Created by Vino_Swify on 25/08/25.

import Foundation
// Domain models/protocols must already exist in your Domain folder
// Weather, ForecastDay, GeoCity, WeatherRepository

final class WeatherRepositoryImpl: WeatherRepository {
    private let weather: WeatherManager
    init(weather: WeatherManager = .shared) { self.weather = weather }

    func current(lat: Double, lon: Double) async throws -> Weather {
        let dto = try await weather.getCurrent(lat: lat, lon: lon)
        return Weather(
            city: dto.name,
            tempC: dto.main.temp,
            feelsLikeC: dto.main.feels_like,
            condition: dto.weather.first?.main ?? "—",
            humidity: dto.main.humidity,
            windKph: dto.wind.speed * 3.6
        )
    }

    func forecast(lat: Double, lon: Double) async throws -> [ForecastDay] {
        let dto = try await weather.getForecast(lat: lat, lon: lon)
        let cal = Calendar(identifier: .gregorian)
        let groups = Dictionary(grouping: dto.list) { item in
            Date(timeIntervalSince1970: item.dt).stripTime(cal)
        }
        return groups.keys.sorted().compactMap { day in
            guard let items = groups[day] else { return nil }
            let minC = items.map { $0.main.temp }.min() ?? 0
            let maxC = items.map { $0.main.temp }.max() ?? 0
            let symbol = symbolFromCondition(items.compactMap { $0.weather.first?.main })
            return ForecastDay(date: day, minC: minC, maxC: maxC, symbol: symbol)
        }
    }

    func searchCities(query: String) async throws -> [GeoCity] {
        let list = try await weather.geocode(query)
        return list.map { GeoCity(name: $0.name, country: $0.country, lat: $0.lat, lon: $0.lon) }
    }

    // MARK: - Helpers
    private func symbolFromCondition(_ conditions: [String]) -> String {
        let joined = conditions.joined(separator: " ").lowercased()

        if joined.contains(WeatherKeywords.rain) {
            return SystemIcons.rain
        }
        if joined.contains(WeatherKeywords.thunder) || joined.contains(WeatherKeywords.storm) {
            return SystemIcons.storm
        }
        if joined.contains(WeatherKeywords.snow) {
            return SystemIcons.snow
        }
        if joined.contains(WeatherKeywords.fog) || joined.contains(WeatherKeywords.mist) {
            return SystemIcons.fog
        }
        if joined.contains(WeatherKeywords.cloud) {
            return SystemIcons.cloud
        }
        return SystemIcons.sun
    }
}

private extension Date {
    func stripTime(_ cal: Calendar) -> Date { cal.startOfDay(for: self) }
}
