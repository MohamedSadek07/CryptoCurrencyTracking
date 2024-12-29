//
//  CurrencyDetailsFactory.swift
//  iJusoor
//
//  Created by Mohamed Sadek on 28/12/2024.
//
import SwiftUI
/// Defines the router functionalities
final class CurrencyDetailsFactory {

    static func createModule(currencyID: String) -> CurrencyDetailsView {
        let remoteRepo = CurrencyDetailsRemoteRepository()
        let localRepo = CurrenciesListLocalRepository()
        let currencyDetailsUseCase = CurrencyDetailsUseCase(remoteCurrencyDetailsRepo: remoteRepo,
                                                            localCurrenciesListRepo: localRepo)
        let viewModel = CurrencyDetailsViewModel(currencyDetailsUseCase: currencyDetailsUseCase,
                                                 currencyID: currencyID)
        let view = CurrencyDetailsView(viewModel: viewModel)
        return view
    }
}
