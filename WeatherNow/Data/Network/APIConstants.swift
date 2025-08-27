//  APIConstants.swift
//  Created by Vino_Swify on 25/08/25.

import Foundation

enum APIConstants {
    /// Cloudflare Worker endpoint that proxies requests to OpenWeatherMap.
    /// - The real API key is stored securely in Cloudflare (server-side).
    /// - The client (iOS app) never sees or ships the key.
    /// - Worker injects the secret automatically before calling OpenWeather.
    static let baseUrl = "https://weatherapp.vinothkam23.workers.dev"
    
    // Paths
    static let pathWeather = "/weather"
    static let pathForecast = "/forecast"
    static let pathGeocode = "/geocode"
    
    // Query Keys
    static let paramLat = "lat"
    static let paramLon = "lon"
    static let paramUnits = "units"
    static let paramQuery = "q"
    static let paramLimit = "limit"
    
    // Values
    static let unitsMetric = "metric"
    static let defaultGeocodeLimit = 5
}
