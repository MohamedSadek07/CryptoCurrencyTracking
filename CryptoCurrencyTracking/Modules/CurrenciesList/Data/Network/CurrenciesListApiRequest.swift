//
//  CurrenciesListApiRequest.swift
//  CryptoCurrencyTracking
//
//  Created by Mohamed Sadek on 26/12/2024.
//

import Foundation

enum CurrenciesListApiRequest {
    case getCurrenciesList(requestModel: CurrenciesListRequestModel)
    case getSearchResults(requestModel: SearchListRequestModel)
}

extension CurrenciesListApiRequest: NetworkRequest {
    var method: HTTPMethod {
        return .GET
    }

    var path: String {
        switch self {
        case .getCurrenciesList:
            return Constants.Network.baseURL + Constants.Endpoints.coinsList
        case .getSearchResults:
            return Constants.Network.baseURL + Constants.Endpoints.search
        }
    }

    var parameters: Parameters? {
        nil
    }

    var headers: HTTPHeaders? {
        return baseHeaders
    }

    var queryParams: [String : Any]? {
        switch self {
        case let .getCurrenciesList(body):
            return body.asDictionary
        case let .getSearchResults(body):
            return body.asDictionary
        }
    }
}
