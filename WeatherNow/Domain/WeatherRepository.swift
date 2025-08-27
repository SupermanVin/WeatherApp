//  WeatherRepository.swift
//  Created by Vino_Swify on 25/08/25.

import Foundation
public protocol WeatherRepository {
    func current(lat: Double, lon: Double) async throws -> Weather
    func forecast(lat: Double, lon: Double) async throws -> [ForecastDay]
    func searchCities(query: String) async throws -> [GeoCity]
}
