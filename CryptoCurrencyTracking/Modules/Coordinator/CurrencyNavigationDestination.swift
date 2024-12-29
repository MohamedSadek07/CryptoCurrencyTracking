//
//  CurrencyNavigationDestination.swift
//  CryptoCurrencyTracking
//
//  Created by Mohamed Sadek on 28/12/2024.
//

import Foundation

enum CurrencyNavigationDestination: Hashable {
    case currencyList
    case currencyDetail(currencyID: String)
}
