//
//  CurrencyModelItem.swift
//  CryptoCurrencyTracking
//
//  Created by Mohamed Sadek on 26/12/2024.
//

import Foundation

struct CurrencyModelItem: Hashable {
    var id: String
    var name: String
    var symbol : String
    var image: String
    var currentPrice: Double

    init(id: String = "",
         name: String = "",
         symbol: String = "",
         image: String = "",
         currentPrice: Double = 0) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.image = image
        self.currentPrice = currentPrice
    }
}
