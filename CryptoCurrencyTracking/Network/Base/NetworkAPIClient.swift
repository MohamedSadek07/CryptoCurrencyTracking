//
//  NetworkAPIClient.swift
//  AnimationCharacters
//
//  Created by Mohamed Sadek on 24/11/2024.
//

import Foundation
import Combine

protocol NetworkAPIClientProtocol: AnyObject {
    func request<R: Codable>(request: URLRequest, mapToModel: R.Type) -> AnyPublisher<R, NetworkError>
}

final class NetworkAPIClient: NetworkAPIClientProtocol {
    private var configuration: URLSessionConfiguration
    private var session: URLSession
    init(configuration: URLSessionConfiguration, session: URLSession) {
        self.configuration = configuration
        self.session = session
    }
    func request<R: Codable>(request: URLRequest, mapToModel: R.Type) -> AnyPublisher<R, NetworkError> {
        Log.info(request.httpMethod?.description ?? "")
        Log.info(request.url?.description ?? "")
        Log.info(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "")
        return session.dataTaskPublisher(for: request)
            .tryMap { result in
                guard let httpResponse = result.response as? HTTPURLResponse else {
                    throw NetworkError.requestFailed
                }
                if (200..<300) ~= httpResponse.statusCode {
                    Log.info("✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅")
                    Log.info(String(data: result.data, encoding: .utf8) ?? "")
                    return result.data
                } else if httpResponse.statusCode == 401 {
                    Log.error("Unauthorithed  error with code 401: ================ ")
                    throw NetworkError.unAuthorithed
                } else if httpResponse.statusCode == 1009 || httpResponse.statusCode == 1020 {
                    throw NetworkError.noInternetConnection
                } else {
                    if let error = try? JSONDecoder().decode(NetworkErrorResponse.self, from: result.data) {
                        Log.error("Internal error: ================ ")
                        Log.error(error.error ?? "")
                        throw NetworkError.internalError(error)

                    } else {
                        Log.error("Something went wrong error: ================ ")
                        Log.error("with status code \(httpResponse.statusCode.description)")
                        throw NetworkError.emptyErrorWithStatusCode(httpResponse.statusCode.description)
                    }
                }
            }
            .receive(on: DispatchQueue.main)
            .decode(type: R.self, decoder: JSONDecoder())
            .mapError({ error -> NetworkError in
                if let error = error as? NetworkError {
                    return error
                }
                Log.error("Normal error")
                Log.error("Decode error")
                if let decodingError = error as? Swift.DecodingError {
                    switch decodingError {
                    case .typeMismatch(let key, let value):
                        Log.error("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
                    default: break
                    }
                }
                Log.error(error.localizedDescription)
                return NetworkError.normalError(error)
            })
            .eraseToAnyPublisher()
    }
}
