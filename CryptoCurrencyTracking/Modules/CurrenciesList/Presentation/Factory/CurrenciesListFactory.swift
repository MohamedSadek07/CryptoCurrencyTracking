//
//  CurrenciesListFactory.swift
//  iJusoor
//
//  Created by Mohamed Sadek on 26/12/2024.
//
import SwiftUI
/// Defines the router functionalities
final class CurrenciesListFactory {

    static func createModule() -> CurrenciesListView {
        let remoteRepo = CurrenciesListRemoteRepository()
        let localRepo = CurrenciesListLocalRepository()
        let currenciesListUseCase = CurrenciesListUseCase(remoteCurrenciesListRepo: remoteRepo,
                                                          localCurrenciesListRepo: localRepo)
        let viewModel = CurrenciesListViewModel(currenciesListUseCase: currenciesListUseCase)
        let view = CurrenciesListView(viewModel: viewModel)
        return view
    }
}
