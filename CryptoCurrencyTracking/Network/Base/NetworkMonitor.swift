//
//  NetworkMonitor.swift
//  CryptoCurrencyTracking
//
//  Created by Mohamed Sadek on 27/12/2024.
//

import Foundation
import Network

class NetworkMonitor: ObservableObject {
    // MARK: Variables
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .userInitiated)
    // MARK: - Published Varables
    @Published var isConnected: Bool = true
    // MARK: - Init
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isConnected = (path.status == .satisfied)
            }
        }
        monitor.start(queue: queue)
    }
}
