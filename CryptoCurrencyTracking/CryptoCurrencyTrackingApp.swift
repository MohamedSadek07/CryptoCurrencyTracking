//
//  CryptoCurrencyTrackingApp.swift
//  CryptoCurrencyTracking
//
//  Created by Mohamed Sadek on 25/12/2024.
//

import SwiftUI

@main
struct CryptoCurrencyTrackingApp: App {
    var body: some Scene {
        WindowGroup {
            CurrenciesListFactory.createModule()
        }
    }
}
