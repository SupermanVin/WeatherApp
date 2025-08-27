//  NetworkConstants.swift
//  WeatherNow
//  Created by Vino_Swify on 27/08/25.

import Foundation
enum NetworkConstants {
    // Headers
    static let headerAppToken = "X-App-Token"
    static let headerContentType = "Content-Type"
    
    // Content Types
    static let contentTypeForm = "application/x-www-form-urlencoded; charset=utf-8"
    static let contentTypeJSON = "application/json"
    
    // Hosts
    static let cloudflareHostSuffix = "workers.dev"
    static let vinothWorkerHost = "vinothkam23.workers.dev"
    
    // Timeout
    static let defaultTimeout: TimeInterval = 15
}
