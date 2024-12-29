//
//  CurrenciesListView.swift
//  iJusoor
//
//  Created by Mohamed Sadek on 26/12/2024.
//

import SwiftUI
import Combine

struct CurrenciesListView: View {
    // MARK: Variables
    @StateObject var viewModel: CurrenciesListViewModel
    // MARK: - Init
    init(viewModel: CurrenciesListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    //MARK: Body
    var body: some View {
        NavigationView {
            // FavoritesButton and List of currencies with searchBar
            VStack(alignment: .leading, spacing: 10) {
                favoritesButton
                .padding(.horizontal, 14)

                currenciesList
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .searchable(text: $viewModel.searchText)
            .navigationTitle(viewModel.title)
        }
        .task {
            // Fetch data on view load
            viewModel.getCurrenciesList()
            viewModel.setupAutoRefresh()
        }
        .onDisappear {
            viewModel.removeAllSubscribers()
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

    var favoritesButton: some View {
        Button(action: {
            viewModel.favoritesButtonTapped()
           }) {
               Text("Favorites")
                   .padding(.horizontal, 12)
                   .padding(.vertical, 6)
                   .background(viewModel.isFavorited ? Color.blue : Color.clear)
                   .foregroundColor(viewModel.isFavorited ? .white : .blue)
                   .cornerRadius(20)
                   .overlay(
                       RoundedRectangle(cornerRadius: 20)
                           .stroke(Color.blue, lineWidth: 2)
                   )
           }
           .animation(.easeInOut, value: viewModel.isFavorited)
    }

    @ViewBuilder
    var currenciesList: some View {
        if !viewModel.returnedCurrencies.isEmpty {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.returnedCurrencies, id: \.self) { item in
                        Button(action: {
                            viewModel.didSelectCurrency(with: item.id)
                        }) {
                            CurrencyItemView(currency: item, favoriteAction: { isFavorite, item in
                                viewModel.handleFavoriteAction(isFavorite, item)
                            }, isFavoriteListPresented: viewModel.isFavorited)
                            .padding(.horizontal)
                            .padding(.vertical, 6)
                        }
                    }
                }
            }
        } else {
            Text(viewModel.isFavorited ? "There is not any favorites" : "There is not any currency yet")
                .font(.title3)
                .fontWeight(.medium)
                .padding(.horizontal, 60)
                .padding(.top, 100)
            Spacer()
        }
    }
}
