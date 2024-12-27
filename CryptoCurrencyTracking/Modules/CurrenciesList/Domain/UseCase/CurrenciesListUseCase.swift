//
//  CurrenciesListUseCase.swift
//  iJusoor
//
//  Created by Mohamed Sadek on 26/12/2024.
//

import Foundation
import Combine

protocol CurrenciesListUseCaseProtocol: AnyObject {
    func fetchCurrenciesList(requestModel: CurrenciesListRequestModel) -> AnyPublisher< [CurrencyModelItem], NetworkError>
    func getSearchCurrenciesResults(requestModel: SearchListRequestModel) -> AnyPublisher<[CurrencyModelItem], NetworkError>
}

class CurrenciesListUseCase: CurrenciesListUseCaseProtocol {
    //MARK: Variables
    private let remoteCurrenciesListRepo: CurrenciesListRemoteRepositoryProtocol
    private var cancelable: Set<AnyCancellable> = []
    //MARK: Init
    init(remoteCurrenciesListRepo: CurrenciesListRemoteRepositoryProtocol) {
        self.remoteCurrenciesListRepo = remoteCurrenciesListRepo
    }
    //MARK: Methods
    private func mapCurrencies(_ response: CurrenciesListResponseModel) -> [CurrencyModelItem] {
        return response.map { currency in
            CurrencyModelItem(id: currency.id ?? "",
                              name: currency.name ?? "",
                              symbol: currency.symbol ?? "",
                              image: currency.image ?? "",
                              currentPrice: currency.currentPrice ?? 0.0
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

/// UseCase Extension
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
