//  HttpMethod.swift
//  Created by Vino_Swify on 25/08/25.

import Foundation

enum HttpTask {
    case requestPlain
    case requestParameters(
        bodyParameters: [String: Any]?,
        urlParameters: [String: Any]?,
        encoding: ParameterEncoding = .url
    )
}
