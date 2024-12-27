//
//  CurrenciesListRequestModel.swift
//  CryptoCurrencyTracking
//
//  Created by Mohamed Sadek on 27/12/2024.
//

import Foundation


struct CurrenciesListRequestModel: Codable {
    let vsCurrency: String?

    enum CodingKeys: String, CodingKey {
        case vsCurrency = "vs_currency"
    }
}
