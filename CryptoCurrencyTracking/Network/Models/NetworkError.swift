//
//  NetworkError.swift
//  AnimationCharacters
//
//  Created by Mohamed Sadek on 24/11/2024.
//

import Foundation

enum NetworkError: Error {
    case normalError(Error)
    case notValidURL
    case noInternetConnection
    case unAuthorithed(UnauthorizedNetworkErrorResponse)
    case requestFailed
    case internalError(NetworkErrorResponse)
    case fetchingError(GeneralErrorResponse)
    case emptyErrorWithStatusCode(String)
    case decodeFailed
}
