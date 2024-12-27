//
//  CurrencyItemView.swift
//  CryptoCurrencyTracking
//
//  Created by Mohamed Sadek on 26/12/2024.
//

import SwiftUI

struct CurrencyItemView: View {
    // MARK: Variables
    let currency: CurrencyModelItem
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
            
            // Current Price
            if currency.currentPrice != 0.0 {
                Text("$\(currency.currentPrice, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}


#Preview {
    CurrencyItemView(currency: CurrencyModelItem(id: "",
                                                 name: "",
                                                 symbol: "",
                                                 image: "",
                                                 currentPrice: 0.0))
}
