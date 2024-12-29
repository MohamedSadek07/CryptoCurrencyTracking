//
//  Constants.swift
//  CryptoCurrencyTracking
//
//  Created by Mohamed Sadek on 26/12/2024.
//
import Foundation

enum Constants {
  enum Network {
    static let baseURL = "https://api.coingecko.com/api/v3/"
  }

  enum Endpoints {
    static let coinsList = "coins/markets"
    static let search = "search"
    static let coinDetail = "coins"
    }
}
