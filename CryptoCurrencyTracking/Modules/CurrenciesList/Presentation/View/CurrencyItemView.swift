//
//  CurrencyItemView.swift
//  CryptoCurrencyTracking
//
//  Created by Mohamed Sadek on 26/12/2024.
//

import SwiftUI

struct CurrencyItemView: View {
    // MARK: Variables
    var currency: CurrencyModelItem
    var favoriteAction: (_ isFavorite: Bool, _ item: CurrencyModelItem) -> Void
    var isFavoriteListPresented: Bool
    // MARK: Body
    var body: some View {
        HStack(spacing: 16) {
            // Currency Image
            AsyncImage(url: URL(string: currency.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 50, height: 50)
                    .overlay(
                        ProgressView()
                    )
            }

            // Currency Details
            VStack(alignment: .leading, spacing: 4) {
                Text(currency.name)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(currency.symbol)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()

            VStack(alignment: .trailing) {
                if !isFavoriteListPresented {
                    // Favorite Button
                    Button(action: {
                        toggleFavorite()
                    }) {
                        Image(systemName: currency.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(currency.isFavorite ? .red : .gray)
                    }
                }
                // Current Price
                if currency.currentPrice != 0.0 {
                    Text("$\(currency.currentPrice, specifier: "%.2f")")
                        .font(.headline)
                        .foregroundColor(.green)
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 2)
    }

    private func toggleFavorite() {
        if currency.isFavorite {
            // remove from favorites
            favoriteAction(false, currency)
        } else {
            // add to favorites
            favoriteAction(true, currency)
        }
    }
}
