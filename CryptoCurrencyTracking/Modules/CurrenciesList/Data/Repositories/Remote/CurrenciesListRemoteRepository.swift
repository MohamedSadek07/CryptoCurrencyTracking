//
//  CurrenciesListRemoteRepository.swift
//  iJusoor
//
//  Created by Mohamed Sadek on 26/12/2024.
//

import Foundation
import Combine

class CurrenciesListRemoteRepository {
    let networkApiClient = NetworkAPIClient(configuration: URLSession.shared.configuration, session: .shared)
}


extension CurrenciesListRemoteRepository: CurrenciesListRemoteRepositoryProtocol {
    func fetchCurrenciesList(requestModel: CurrenciesListRequestModel) -> AnyPublisher<CurrenciesListResponseModel, NetworkError> {
        networkApiClient.request(
            request: CurrenciesListApiRequest.getCurrenciesList(requestModel: requestModel).asURLRequest,
          mapToModel: CurrenciesListResponseModel.self
        )
    }

    func getSearchCurrenciesResults(requestModel: SearchListRequestModel) -> AnyPublisher<SearchListResponseModel, NetworkError> {
        networkApiClient.request(
            request: CurrenciesListApiRequest.getSearchResults(requestModel: requestModel).asURLRequest,
            mapToModel: SearchListResponseModel.self
        )
    }
}
