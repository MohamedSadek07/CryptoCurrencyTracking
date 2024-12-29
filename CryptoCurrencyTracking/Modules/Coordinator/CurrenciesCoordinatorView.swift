//
//  CurrenciesCoordinatorView.swift
//  CryptoCurrencyTracking
//
//  Created by Mohamed Sadek on 28/12/2024.
//

import SwiftUI

struct CurrenciesCoordinatorView: View {
    @StateObject private var coordinator = CurrenciesCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .currencyList)
                .navigationDestination(for: CurrencyNavigationDestination.self) { destination in
                    coordinator.build(page: destination)
                }
        }
    }
}
