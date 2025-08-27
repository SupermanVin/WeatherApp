//  HttpMethod.swift
//  WeatherNow
//  Created by Vino_Swify on 25/08/25.
import Foundation

protocol EndpointType {
    var baseURL: URL { get }
    var path: String { get }
    var method: HttpMethod { get }
    var task: HttpTask { get }
    var headers: [String:String]? { get }
}
