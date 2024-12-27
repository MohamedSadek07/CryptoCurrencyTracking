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
            // List of currencies with SearchBar
            VStack {
                List(viewModel.returnedCurrencies, id: \.self) { item in
                    CurrencyItemView(currency: item)
                        .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
            }
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
}

struct CurrenciesList_Previews: PreviewProvider {
    static var previews: some View {
        CurrenciesListFactory.createModule()
    }
}
