//
//  Endpoint.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import Foundation

typealias HTTPQueries = [String: String]
typealias HTTPHeaders = [String: String]

protocol RequestBuilder {
    func buildRequest(baseURL: URL, apiKey: String) -> URLRequest?
}

protocol Endpoint: RequestBuilder {
    var baseURL: URL? { get }
    var path: String? { get }
    var httpMethod: HTTPMethods { get }
    var queries: HTTPQueries { get }
    var headers: HTTPHeaders { get }
}

// MARK: - Endpoint Extension
extension Endpoint {
    // MARK: - Properties
    var baseURL: URL? { return nil }
    
    // MARK: - Methods
    func buildRequest(baseURL: URL, apiKey: String) -> URLRequest? {
        var completeURL = self.baseURL ?? baseURL
        guard let path = path else {
            return nil
        }
        completeURL = completeURL.appendingPathComponent(path)
        
        guard var components = URLComponents(
            url: completeURL,
            resolvingAgainstBaseURL: true) else {
            return nil
        }
        
        components.queryItems = queries.map { item in
            URLQueryItem(name: item.key, value: item.value)
        }
        components.queryItems?.insert(URLQueryItem(name: "api_key", value: apiKey), at: 0)
        guard let urlForRequest = components.url else {
            return nil
        }
        var urlRequest = URLRequest(url: urlForRequest)
        urlRequest.httpMethod = httpMethod.rawValue
        
        headers.forEach { (key: String, value: String) in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        return urlRequest
    }
}
