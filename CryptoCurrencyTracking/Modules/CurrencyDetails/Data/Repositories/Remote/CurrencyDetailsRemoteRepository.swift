//
//  CurrencyDetailsRemoteRepository.swift
//  iJusoor
//
//  Created by Mohamed Sadek on 28/12/2024.
//

import Foundation
import Combine

class CurrencyDetailsRemoteRepository {
    let networkApiClient = NetworkAPIClient(configuration: URLSession.shared.configuration, session: .shared)
}


extension CurrencyDetailsRemoteRepository: CurrencyDetailsRemoteRepositoryProtocol {
    func getCurrencyDetails(requestModel: CurrencyDetailsRequestModel) -> AnyPublisher<CurrencyDetailsResponseModel, NetworkError> {
        networkApiClient.request(
          request: CurrencyDetailsApiRequest.getCurrencyDetails(requestModel: requestModel).asURLRequest,
          mapToModel: CurrencyDetailsResponseModel.self
        )
    }
}
