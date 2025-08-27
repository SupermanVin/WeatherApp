//  HttpMethod.swift
//  Created by Vino_Swify on 25/08/25.
import Foundation

enum WeatherAPI {
    case current(lat: Double, lon: Double)
    case forecast(lat: Double, lon: Double)
    case geocode(query: String)
}

extension WeatherAPI: EndpointType {
    var baseURL: URL { URL(string: APIConstants.baseUrl)! }

    var path: String {
        switch self {
        case .current:  return APIConstants.pathWeather
        case .forecast: return APIConstants.pathForecast
        case .geocode:  return APIConstants.pathGeocode
        }
    }

    var method: HttpMethod { .get }

    var task: HttpTask {
        switch self {
        case let .current(lat, lon), let .forecast(lat, lon):
            return .requestParameters(
                bodyParameters: nil,
                urlParameters: [
                    APIConstants.paramLat: lat,
                    APIConstants.paramLon: lon,
                    APIConstants.paramUnits: APIConstants.unitsMetric
                ],
                encoding: .url
            )

        case let .geocode(q):
            return .requestParameters(
                bodyParameters: nil,
                urlParameters: [
                    APIConstants.paramQuery: q,
                    APIConstants.paramLimit: APIConstants.defaultGeocodeLimit
                ],
                encoding: .url
            )
        }
    }

    var headers: [String: String]? { nil }
}
