//
//  CurrenciesListUseCase.swift
//  iJusoor
//
//  Created by Mohamed Sadek on 26/12/2024.
//

import Foundation
import Combine

protocol CurrenciesListUseCaseProtocol: AnyObject {
    /// Remote
    func fetchCurrenciesList(requestModel: CurrenciesListRequestModel) -> AnyPublisher< [CurrencyModelItem], NetworkError>
    func getSearchCurrenciesResults(requestModel: SearchListRequestModel) -> AnyPublisher<[CurrencyModelItem], NetworkError>
    /// Local
    func getFavorites() -> [CurrencyModelItem]
    func addFavorite(_ item: CurrencyModelItem)
    func removeFavorite(_ item: CurrencyModelItem)
}

class CurrenciesListUseCase: CurrenciesListUseCaseProtocol {
    //MARK: Variables
    private let remoteCurrenciesListRepo: CurrenciesListRemoteRepositoryProtocol
    private let localCurrenciesListRepo: CurrenciesListLocalRepositoryProtocol
    private var cancelable: Set<AnyCancellable> = []
    //MARK: Init
    init(remoteCurrenciesListRepo: CurrenciesListRemoteRepositoryProtocol, localCurrenciesListRepo: CurrenciesListLocalRepositoryProtocol) {
        self.remoteCurrenciesListRepo = remoteCurrenciesListRepo
        self.localCurrenciesListRepo = localCurrenciesListRepo
    }
    //MARK: Methods
    private func mapCurrencies(_ response: CurrenciesListResponseModel) -> [CurrencyModelItem] {
        return response.map { currency in
            CurrencyModelItem(id: currency.id ?? "",
                              name: currency.name ?? "",
                              symbol: currency.symbol ?? "",
                              image: currency.image ?? "",
                              currentPrice: currency.currentPrice ?? 0.0,
                              isFavorite: localCurrenciesListRepo.isFavorite(currency.id ?? "")
            )
        }
    }

    private func mapSearchResults(_ response: SearchListResponseModel) -> [CurrencyModelItem] {
        return response.coins?.map { currency in
            CurrencyModelItem(id: currency.id ?? "",
                              name: currency.name ?? "",
                              symbol: currency.symbol ?? "",
                              image: currency.large ?? "",
                              currentPrice: 0.0
            )
        } ?? []
    }
}

/// Remote UseCase Extension
extension CurrenciesListUseCase {
    func fetchCurrenciesList(requestModel: CurrenciesListRequestModel) -> AnyPublisher< [CurrencyModelItem], NetworkError> {
        return Future<[CurrencyModelItem], NetworkError> { [weak self] promise in
            guard let self else { return }
            remoteCurrenciesListRepo.fetchCurrenciesList(requestModel: requestModel)
                .sink(
                    receiveCompletion: { result in
                        if case .failure(let error) = result {
                            promise(.failure(error))
                        }
                    },
                    receiveValue: {[weak self] response in
                        guard let self else { return }
                        promise(.success(mapCurrencies(response)))
                    }).store(in: &cancelable)
        }
        .eraseToAnyPublisher()
    }

    func getSearchCurrenciesResults(requestModel: SearchListRequestModel) -> AnyPublisher<[CurrencyModelItem], NetworkError> {
        return Future<[CurrencyModelItem], NetworkError> { [weak self] promise in
            guard let self else { return }
            remoteCurrenciesListRepo.getSearchCurrenciesResults(requestModel: requestModel)
                .sink(
                    receiveCompletion: { result in
                        if case .failure(let error) = result {
                            promise(.failure(error))
                        }
                    },
                    receiveValue: {[weak self] response in
                        guard let self else { return }
                        promise(.success(mapSearchResults(response)))
                    }).store(in: &cancelable)
        }
        .eraseToAnyPublisher()
    }
}


/// Local UseCase Extension
extension CurrenciesListUseCase {
    func getFavorites() -> [CurrencyModelItem] {
        localCurrenciesListRepo.getFavorites()
    }

    func addFavorite(_ item: CurrencyModelItem) {
        localCurrenciesListRepo.addFavorite(item)
    }

    func removeFavorite(_ item: CurrencyModelItem) {
        localCurrenciesListRepo.removeFavorite(item)
    }
}
