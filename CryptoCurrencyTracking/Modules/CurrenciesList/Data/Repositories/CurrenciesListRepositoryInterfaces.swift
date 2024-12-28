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

protocol CurrenciesListLocalRepositoryProtocol: AnyObject {
    func getFavorites() -> [CurrencyModelItem]
    func addFavorite(_ item: CurrencyModelItem)
    func removeFavorite(_ item: CurrencyModelItem)
    func isFavorite(_ id: String) -> Bool
}
