//  HttpMethod.swift
//  Created by Vino_Swify on 25/08/25.

import Foundation

/// Singleton network layer for sending API requests
/// - Handles request building, headers, encoding, and decoding
final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    /// Sends a request to the given endpoint and decodes the response into a model
    func send<T: Decodable>(
        _ endpoint: EndpointType,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> T {
        let request = try buildRequest(from: endpoint)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Validate response type
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        // Validate status code
        guard (200..<300).contains(http.statusCode) else {
            throw NetworkError.statusCode(http.statusCode)
        }
        
        // Decode response body into expected model
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decoding(error)
        }
    }
    
    // MARK: - Private Helpers
    /// Builds a URLRequest from the given endpoint definition
    private func buildRequest(from ep: EndpointType) throws -> URLRequest {
        let url = ep.baseURL.appendingPathComponent(ep.path)
        var req = URLRequest(url: url)
        req.httpMethod = ep.method.rawValue
        
        // 1) Apply endpoint-specific headers (if any)
        ep.headers?.forEach { req.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        // 2) Add shared Cloudflare Worker token (for proxy security)
        if let host = ep.baseURL.host,
           (host.contains(NetworkConstants.cloudflareHostSuffix) ||
            host.contains(NetworkConstants.vinothWorkerHost)) {
            
            if let token = Secrets.workerClientToken(), !token.isEmpty {
                req.addValue(token, forHTTPHeaderField: NetworkConstants.headerAppToken)
            }
        }
        
        // 3) Attach query parameters and/or body
        switch ep.task {
        case .requestPlain:
            break
            
        case let .requestParameters(body, query, encoding):
            // Query params
            if let query, !query.isEmpty {
                var comps = URLComponents(url: url, resolvingAgainstBaseURL: false)!
                comps.queryItems = (comps.queryItems ?? []) + query.map {
                    URLQueryItem(name: $0.key, value: "\($0.value)")
                }
                req.url = comps.url
            }
            
            // Body params
            if let body, !body.isEmpty {
                switch encoding {
                case .url:
                    let form = body
                        .map { "\($0.key)=\("\($0.value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
                        .joined(separator: "&")
                    req.setValue(NetworkConstants.contentTypeForm,
                                 forHTTPHeaderField: NetworkConstants.headerContentType)
                    req.httpBody = form.data(using: .utf8)
                    
                case .json:
                    req.setValue(NetworkConstants.contentTypeJSON,
                                 forHTTPHeaderField: NetworkConstants.headerContentType)
                    req.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
                }
            }
        }
        
        // 4) Apply default timeout
        req.timeoutInterval = NetworkConstants.defaultTimeout
        return req
    }
}

