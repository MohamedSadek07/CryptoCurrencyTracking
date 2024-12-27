//
//  SearchListResponseModel.swift
//  CryptoCurrencyTracking
//
//  Created by Mohamed Sadek on 27/12/2024.
//

import Foundation

// MARK: - SearchListResponseModel
struct SearchListResponseModel: Codable {
    let coins: [Coin]?
    let exchanges: [Exchange]?
    let icos: [String]?
    let categories: [Category]?
    let nfts: [Nft]?
}

// MARK: - Category
struct Category: Codable {
    let id, name: String?
}

// MARK: - Coin
struct Coin: Codable {
    let id, name, apiSymbol, symbol: String?
    let marketCapRank: Int?
    let thumb, large: String?

    enum CodingKeys: String, CodingKey {
           case id, name
           case apiSymbol = "api_symbol"
           case symbol
           case marketCapRank = "market_cap_rank"
           case thumb, large
       }
}

// MARK: - Exchange
struct Exchange: Codable {
    let id, name, marketType: String?
    let thumb, large: String?
    
    enum CodingKeys: String, CodingKey {
           case id, name
           case marketType = "market_type"
           case thumb, large
       }
}

// MARK: - Nft
struct Nft: Codable {
    let id, name, symbol: String?
    let thumb: String?
}
