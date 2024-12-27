//
//  CurrenciesListRepositoryInterfaces.swift
//  iJusoor
//
//  Created by Mohamed Sadek on 26/12/2024.
//

import Foundation
import Combine

protocol CurrenciesListRemoteRepositoryProtocol: AnyObject {
    func fetchCurrenciesList(requestModel: CurrenciesListRequestModel) -> AnyPublisher<CurrenciesListResponseModel, NetworkError>
    func getSearchCurrenciesResults(requestModel: SearchListRequestModel) -> AnyPublisher<SearchListResponseModel, NetworkError>
}
