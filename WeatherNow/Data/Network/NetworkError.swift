//  HttpMethod.swift
//  Created by Vino_Swify on 25/08/25.

import Foundation

enum NetworkError: Error {
    case buildRequestFailed
    case network(Error)
    case invalidResponse
    case statusCode(Int)
    case noData
    case decoding(Error)
}
