//  Model+Mocks.swift
//  WeatherNow_UnitTests
//  Created by Vino_Swify on 27/08/25.

import Foundation
@testable import WeatherNow

extension Weather {
    static let mock = Weather(
        city: "Chennai",
        tempC: 25,
        feelsLikeC: 27,
        condition: "Sunny",
        humidity: 60,
        windKph: 10.0
    )
}

extension ForecastDay {
    static let mock = ForecastDay(
        date: Date(),
        minC: 20,
        maxC: 30,
        symbol: "sun.max.fill"
    )

    static func mocks(count: Int = 5) -> [ForecastDay] {
        (0..<count).map { i in
            ForecastDay(
                date: Calendar.current.date(byAdding: .day, value: i, to: Date())!,
                minC: 18 + Double(i),
                maxC: 28 + Double(i),
                symbol: i % 2 == 0 ? "sun.max.fill" : "cloud.rain.fill"
            )
        }
    }
}

extension GeoCity {
    static let mock = GeoCity(
        name: "Chennai",
        country: "IN",
        lat: 13.08,
        lon: 80.27
    )

    static let mocks: [GeoCity] = [
        GeoCity(name: "Chennai", country: "IN", lat: 13.08, lon: 80.27),
        GeoCity(name: "Bengaluru", country: "IN", lat: 12.97, lon: 77.59),
        GeoCity(name: "Mumbai", country: "IN", lat: 19.07, lon: 72.87)
    ]
}
