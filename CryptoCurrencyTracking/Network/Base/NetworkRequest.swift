//
//  NetworkRequest.swift
//  AnimationCharacters
//
//  Created by Mohamed Sadek on 24/11/2024.
//

import Foundation

protocol NetworkRequest {
    var path: String { get }
    var headers: HTTPHeaders? { get }
    var queryParams: Parameters? { get }
    var parameters: Parameters? { get }
    var method: HTTPMethod { get }
}

extension NetworkRequest {
    private var baseHeaders: HTTPHeaders {
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
        ]
        return headers
    }

    private func addQueryItems(queryParams: [String: Any]) -> [URLQueryItem] {
        return queryParams.map { key, value in
            if let arrayValue = value as? [Any] {
                // If the value is an array, format it as a comma-separated string
                let formattedValue = arrayValue.map { String(describing: $0) }.joined(separator: ",")
                return URLQueryItem(name: key, value: formattedValue)
            } else {
                // For non-array values, convert directly to a string
                return URLQueryItem(name: key, value: String(describing: value))
            }
        }
    }

    var asURLRequest: URLRequest {
        /// URL Components
        guard var urlComponents = URLComponents(string: path) else { return URLRequest(url: URL(string: "") ?? URL(fileURLWithPath: "")) }
        urlComponents.path = "\(urlComponents.path)"

        /// Query Items
        if let queryParams = queryParams {
            urlComponents.queryItems = self.addQueryItems(queryParams: queryParams)
        }
        /// Request
        guard let url = urlComponents.url else { return URLRequest(url: URL(string: "www.google.com")!) }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        /// Header
        if let headers = headers {
            _ = headers.map({
                request.addValue($0.value, forHTTPHeaderField: "\($0.key)")}
            )
        }
        /// Headers
        if let params = parameters {
            let jsonData = try? JSONSerialization.data(withJSONObject: params)
            request.httpBody = jsonData
        }
        return request
    }
}

typealias HTTPHeaders = [String:String]
typealias Parameters = [String: Any]
