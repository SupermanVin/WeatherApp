//  StubWeatherRepository.swift
//  WeatherNow_UnitTests
//  Created by Vino_Swify on 27/08/25.
import XCTest
@testable import WeatherNow

final class StubWeatherRepository: WeatherRepository {
    var stubWeather: Weather
    var stubForecast: [ForecastDay]
    var stubCities: [GeoCity]
    var shouldFail: Bool

    init(
        weather: Weather = .mock,
        forecast: [ForecastDay] = [.mock],
        cities: [GeoCity] = [.mock],
        shouldFail: Bool = false
    ) {
        self.stubWeather = weather
        self.stubForecast = forecast
        self.stubCities = cities
        self.shouldFail = shouldFail
    }

    func current(lat: Double, lon: Double) async throws -> Weather {
        if shouldFail { throw URLError(.badServerResponse) }
        return stubWeather
    }

    func forecast(lat: Double, lon: Double) async throws -> [ForecastDay] {
        if shouldFail { throw URLError(.badServerResponse) }
        return stubForecast
    }

    func searchCities(query: String) async throws -> [GeoCity] {
        if shouldFail { throw URLError(.badServerResponse) }
        return stubCities.filter { $0.name.localizedCaseInsensitiveContains(query) }
    }

}
