//
//  CurrenciesCoordinator.swift
//  CryptoCurrencyTracking
//
//  Created by Mohamed Sadek on 28/12/2024.
//

import SwiftUI

protocol CurrenciesCoordinatorProtocol {
    func push(page: CurrencyNavigationDestination)
    func pop()
    func popToRoot()
}


class CurrenciesCoordinator: ObservableObject, CurrenciesCoordinatorProtocol {
    @Published var path: [CurrencyNavigationDestination] = []

    func push(page: CurrencyNavigationDestination) {
        path.append(page)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }

    @ViewBuilder
    func build(page: CurrencyNavigationDestination) -> some View {
        switch page {
        case .currencyList:
            CurrenciesListFactory.createModule(coordinator: self)
        case let .currencyDetail(currencyID):
            CurrencyDetailsFactory.createModule(currencyID: currencyID)
        }
    }
}
