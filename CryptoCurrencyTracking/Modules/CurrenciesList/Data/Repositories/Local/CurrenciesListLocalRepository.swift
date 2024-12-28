//
//  CurrenciesListLocalRepository.swift
//  CryptoCurrencyTracking
//
//  Created by Mohamed Sadek on 27/12/2024.
//

import Foundation


class CurrenciesListLocalRepository {
    private let defaults = UserDefaults.standard
    private let favoritesKey = "favorites"

    /// Saves the list of favorite currencies to UserDefaults.
    private func saveFavorites(_ favorites: [CurrencyModelItem]) {
        if let data = try? JSONEncoder().encode(favorites) {
            defaults.set(data, forKey: favoritesKey)
        }
    }
}

extension CurrenciesListLocalRepository: CurrenciesListLocalRepositoryProtocol {
    /// Retrieves the list of favorite currencies from UserDefaults.
    func getFavorites() -> [CurrencyModelItem] {
        guard let data = defaults.data(forKey: favoritesKey),
              let favorites = try? JSONDecoder().decode([CurrencyModelItem].self, from: data) else {
            return []
        }
        return favorites
    }

    /// Adds a currency to the list of favorites if it is not already present.
    func addFavorite(_ item: CurrencyModelItem) {
        var favorites = getFavorites()
        if !favorites.contains(item) {
            favorites.append(item)
            saveFavorites(favorites)
        }
    }

    /// Removes a currency from the list of favorites.
    func removeFavorite(_ item: CurrencyModelItem) {
        var favorites = getFavorites()
        favorites.removeAll { $0.id == item.id }
        saveFavorites(favorites)
    }

    /// Checks if a currency is marked as a favorite.
    func isFavorite(_ id: String) -> Bool {
        return getFavorites().contains { $0.id == id }
    }
}
