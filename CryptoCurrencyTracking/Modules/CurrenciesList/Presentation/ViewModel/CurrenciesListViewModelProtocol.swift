//
//  CurrenciesListViewModelProtocol.swift
//  CryptoCurrencyTracking
//
//  Created by Mohamed Sadek on 26/12/2024.
//

import Foundation

protocol CurrenciesListViewModelProtocol {
    func getCurrenciesList()
    func getSearchCurrenciesListResults()
    func setupAutoRefresh()
    func handleFavoriteAction(_ isFavorite: Bool, _ item: CurrencyModelItem)
    func favoritesButtonTapped()
    func didSelectCurrency(with id: String)
    func removeAllSubscribers()
}
