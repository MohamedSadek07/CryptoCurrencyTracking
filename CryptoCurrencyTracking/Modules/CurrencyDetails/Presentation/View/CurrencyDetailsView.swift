//
//  CurrencyDetailsView.swift
//  iJusoor
//
//  Created by Mohamed Sadek on 28/12/2024.
//

import SwiftUI

struct CurrencyDetailsView: View {
    // MARK: - Variables
    @StateObject var viewModel: CurrencyDetailsViewModel
    // MARK: - Init
    init(viewModel: CurrencyDetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Favorites Image
                HStack {
                    Spacer()
                    Image(systemName: viewModel.currencyDetails.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.currencyDetails.isFavorite ? .red : .gray)
                        .frame(width: 40, height: 40)
                }
                .padding(.horizontal, 20)

                // Cryptocurrency Image
                AsyncImage(url: URL(string: viewModel.currencyDetails.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: UIScreen.main.bounds.width - 40, height: 250)
                .clipped()

                // Divider
                Divider()
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)

                // Name, Symbol, and Price
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.currencyDetails.name)
                            .font(.title)
                            .fontWeight(.bold)
                        Text(viewModel.currencyDetails.symbol)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text("$\(viewModel.currencyDetails.currentPrice, specifier: "%.2f")")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.horizontal, 20)

                Spacer()
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.getCurrencyDetails()
        }
        .overlay(alignment: .center) {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text(viewModel.alertTitle),
                  message: Text(viewModel.alertMessage),
                  dismissButton: .default(Text("OK")))
        }
    }
}
