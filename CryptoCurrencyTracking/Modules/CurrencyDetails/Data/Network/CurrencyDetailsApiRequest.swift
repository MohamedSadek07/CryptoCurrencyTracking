//
//  CurrencyDetailsApiRequest.swift
//  CryptoCurrencyTracking
//
//  Created by Mohamed Sadek on 28/12/2024.
//

import Foundation

enum CurrencyDetailsApiRequest {
    case getCurrencyDetails(requestModel: CurrencyDetailsRequestModel)
}

extension CurrencyDetailsApiRequest: NetworkRequest {
    var method: HTTPMethod {
        return .GET
    }

    var path: String {
        switch self {
        case let .getCurrencyDetails(requestModel):
            return Constants.Network.baseURL + "\(Constants.Endpoints.coinDetail)" + "/\(requestModel.id ?? "")"
        }
    }

    var parameters: Parameters? {
        nil
    }

    var headers: HTTPHeaders? {
        return baseHeaders
    }

    var queryParams: [String : Any]? {
        nil
    }
}
