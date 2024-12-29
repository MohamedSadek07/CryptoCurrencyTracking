//
//
//  CurrencyDetailsViewModel.swift
//  iJusoor
//
//  Created by Mohamed Sadek on 28/12/2024.
//

import Foundation
import Combine

class CurrencyDetailsViewModel: ObservableObject {
    //MARK: Variables
    private let currencyDetailsUseCase: CurrencyDetailsUseCaseProtocol
    private var cancelable: Set<AnyCancellable> = []
    var sentCurrencyID = ""
    var alertTitle = ""
    var alertMessage = ""
    //MARK: Published Variables
    @Published var currencyDetails = CurrencyModelItem()
    @Published var isLoading = false
    @Published var showAlert = false
    //MARK: - Init
    init(currencyDetailsUseCase: CurrencyDetailsUseCaseProtocol, currencyID: String) {
        self.currencyDetailsUseCase = currencyDetailsUseCase
        self.sentCurrencyID = currencyID
    }
    //MARK: - Methods
    /// Sets up the alert message and visibility for errors or success messages.
    func setupAlertAttributes(isError: Bool, alertMessage: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            showAlert = true
            alertTitle = isError ? "Error" : "Success"
            self.alertMessage = alertMessage
        }
    }
    /// Switches on error type and report upon that type
    private func errorReporting(error: NetworkError) {
        switch error {
        case let .internalError(errorResponse):
            self.setupAlertAttributes(isError: true, alertMessage: errorResponse.error ?? "")
        case .unAuthorithed:
            self.setupAlertAttributes(isError: true, alertMessage: "Something went wrong while fetching currencies")
        case .noInternetConnection:
            self.setupAlertAttributes(isError: true, alertMessage: "There is no internet connection, please check your connection")
        case let .fetchingError(errorResponse):
            self.setupAlertAttributes(isError: true, alertMessage: errorResponse.status?.errorMessage ?? "")
        case .emptyErrorWithStatusCode:
            self.setupAlertAttributes(isError: true, alertMessage: "Server error")
        default:
            break
        }
    }
}


//MARK: - Extensions
extension CurrencyDetailsViewModel: CurrencyDetailsViewModelProtocol {
    /// Fetches currency details from the API using the provided `CurrencyDetailsUseCase`.
    /// The function sets a loading state, makes the API request, handles success or failure responses,
    /// and updates the `currencyDetails` property with the response data
    func getCurrencyDetails() {
        isLoading = true
        let requestModel = CurrencyDetailsRequestModel(id: sentCurrencyID)
        currencyDetailsUseCase.getCurrencyDetails(requestModel: requestModel)
            .timeout(.seconds(10), scheduler: RunLoop.main)
            .sink(receiveCompletion: { [weak self] result in
                guard let self else { return }
                self.isLoading = false
                switch result {
                case .finished:
                    break
                case .failure(let err):
                    errorReporting(error: err)
                }
            }, receiveValue: { [weak self] response in
                guard let self else { return }
                self.currencyDetails = response
            })
            .store(in: &cancelable)
    }
}
