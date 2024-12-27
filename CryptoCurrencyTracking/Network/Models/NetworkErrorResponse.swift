//
//  NetworkErrorResponse.swift
//  AnimationCharacters
//
//  Created by Mohamed Sadek on 24/11/2024.
//

import Foundation

// MARK: - UnauthorizedNetworkErrorResponse
struct UnauthorizedNetworkErrorResponse: Codable {
    let timestamp: String?
    let errorCode: Int?
    let status: Status?

    enum CodingKeys: String, CodingKey {
        case timestamp
        case errorCode = "error_code"
        case status
    }
}
// MARK: Status
struct Status: Codable {
    let errorMessage: String?

    enum CodingKeys: String, CodingKey {
        case errorMessage = "error_message"
    }
}


// MARK: - NetworkErrorResponse
struct NetworkErrorResponse: Codable {
    let error: String?
}
