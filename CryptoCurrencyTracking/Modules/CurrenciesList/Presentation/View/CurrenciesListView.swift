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
            VStack(alignment: .leading, spacing: 4) {
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
            List(viewModel.returnedCurrencies, id: \.self) { item in
                CurrencyItemView(currency: item, favoriteAction: { isFavorite, item in
                    viewModel.handleFavoriteAction(isFavorite, item)
                }, isFavoriteListPresented: viewModel.isFavorited)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        } else {
            Text("There is not any currency yet")
                .font(.title3)
                .fontWeight(.medium)
                .padding(.horizontal, 50)
                .padding(.top, 100)
            Spacer()
        }
    }
}

struct CurrenciesList_Previews: PreviewProvider {
    static var previews: some View {
        CurrenciesListFactory.createModule()
    }
}
