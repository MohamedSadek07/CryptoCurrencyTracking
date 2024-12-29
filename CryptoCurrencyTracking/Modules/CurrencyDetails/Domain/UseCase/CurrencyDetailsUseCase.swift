//
//  CurrencyDetailsUseCase.swift
//  iJusoor
//
//  Created by Mohamed Sadek on 28/12/2024.
//

import Foundation
import Combine

protocol CurrencyDetailsUseCaseProtocol: AnyObject {
    func getCurrencyDetails(requestModel: CurrencyDetailsRequestModel) -> AnyPublisher<CurrencyModelItem, NetworkError>
}

class CurrencyDetailsUseCase {
    private let remoteCurrencyDetailsRepo: CurrencyDetailsRemoteRepositoryProtocol
    private let localCurrenciesListRepo: CurrenciesListLocalRepositoryProtocol
    private var cancelable: Set<AnyCancellable> = []
    init(remoteCurrencyDetailsRepo: CurrencyDetailsRemoteRepositoryProtocol,
         localCurrenciesListRepo: CurrenciesListLocalRepositoryProtocol) {
        self.remoteCurrencyDetailsRepo = remoteCurrencyDetailsRepo
        self.localCurrenciesListRepo = localCurrenciesListRepo
    }
    private func mapCurrencyDetails(_ response: CurrencyDetailsResponseModel) -> CurrencyModelItem {
        CurrencyModelItem(id: response.id ?? "",
                          name: response.name ?? "",
                          symbol: response.symbol ?? "",
                          image: response.image?.large ?? "",
                          currentPrice: response.marketData?.currentPrice?["usd"] ?? 0.0,
                          isFavorite: localCurrenciesListRepo.isFavorite(response.id ?? ""))
    }
}


extension CurrencyDetailsUseCase: CurrencyDetailsUseCaseProtocol {
    func getCurrencyDetails(requestModel: CurrencyDetailsRequestModel) -> AnyPublisher<CurrencyModelItem, NetworkError> {
        return Future<CurrencyModelItem, NetworkError> { [weak self] promise in
            guard let self else { return }
            remoteCurrencyDetailsRepo.getCurrencyDetails(requestModel: requestModel)
                .sink(
                    receiveCompletion: { result in
                        if case .failure(let error) = result {
                            promise(.failure(error))
                        }
                    },
                    receiveValue: {[weak self] response in
                        guard let self else { return }
                        promise(.success(mapCurrencyDetails(response)))
                    }).store(in: &cancelable)
        }
        .eraseToAnyPublisher()
    }
}

