//  AppConstants.swift
//  WeatherNow
//  Created by Vino_Swify on 27/08/25.

import Foundation

enum AppConstants {
    static let forecastDaysLimit = 5
    static let searchMinLength = 2
    static let searchDebounceNS: UInt64 = 300_000_000 // 300ms
    static let sampleFavourites = ["Bengaluru", "Chennai", "Mumbai"]
}
