//
//
//  CurrenciesListViewModel.swift
//  iJusoor
//
//  Created by Mohamed Sadek on 26/12/2024.
//

import Foundation
import Combine


class CurrenciesListViewModel: ObservableObject {
    //MARK: Variables
    private let currenciesListUseCase: CurrenciesListUseCaseProtocol
    private var cancelable: Set<AnyCancellable> = []
    private var shouldAutoRefresh = true
    var title = "Currencies"
    var alertTitle = ""
    var alertMessage = ""
    var savedCurrenciesList: [CurrencyModelItem] = []
    //MARK: Published Variables
    @Published var searchText: String = ""
    @Published var returnedCurrencies: [CurrencyModelItem] = []
    @Published var filteredItems: [CurrencyModelItem] = []
    @Published var showAlert = false
    @Published var isLoading = false
    @Published var refreshTrigger = PassthroughSubject<Void, Never>()

    //MARK: - Init
    init(currenciesListUseCase: CurrenciesListUseCaseProtocol) {
        self.currenciesListUseCase = currenciesListUseCase
        setupAutoRefresh()
        setupSearchPublisher()
    }
    //MARK: - Methods
    /// Sets up the alert message and visibility for errors or success messages.
    private func setupAlertAttributes(isError: Bool, alertMessage: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            showAlert = true
            alertTitle = isError ? "Error" : "Success"
            self.alertMessage = alertMessage
        }
    }

    /// Setup refreshTrigger listner in order to trigger currencies API calling with 30 seconds debounce
    private func setupAutoRefresh() {
        refreshTrigger
            .debounce(for: .seconds(30), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                guard let self, self.shouldAutoRefresh else { return }
                getCurrenciesList()
            }
            .store(in: &cancelable)
    }

    /// Setup searchText listner with 700 milliseconds debounce in order to call searchAPI if search keyword isn't empty and reset it, if it's empty
    private func setupSearchPublisher() {
        $searchText
            .debounce(for: .milliseconds(700), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchTerm in
                guard let self = self else { return }
                if searchTerm.isEmpty {
                    self.returnedCurrencies = self.savedCurrenciesList
                    startAutoRefresh()
                } else {
                    stopAutoRefresh()
                    getSearchCurrenciesListResults()
                }
            }
            .store(in: &cancelable)
    }

    /// Starts the auto-refresh mechanism by enabling it and sending a refresh trigger.
    private func startAutoRefresh() {
         shouldAutoRefresh = true
         refreshTrigger.send()
     }

    /// Stops the auto-refresh mechanism by disabling it.
    private func stopAutoRefresh() {
         shouldAutoRefresh = false
     }
}

//MARK: - Extensions
extension CurrenciesListViewModel: CurrenciesListViewModelProtocol {
    /// Fetches the list of currencies from the API.
    /// Displays a loading indicator while the request is in progress and updates the `returnedCurrencies` and `savedCurrenciesList` once the data is fetched.
    func getCurrenciesList() {
        isLoading = true
        let requestModel = CurrenciesListRequestModel(vsCurrency: "USD")
        currenciesListUseCase.fetchCurrenciesList(requestModel: requestModel)
            .timeout(.seconds(10), scheduler: RunLoop.main)
            .sink(receiveCompletion: { [weak self] result in
                guard let self else { return }
                self.isLoading = false
                switch result {
                case .finished:
                    break
                case .failure(let err):
                    switch err {
                    case let .internalError(errorResponse):
                        self.setupAlertAttributes(isError: true, alertMessage: errorResponse.error ?? "")
                    case .unAuthorithed:
                        self.setupAlertAttributes(isError: true, alertMessage: "Something went wrong while fetching currencies")
                    case .noInternetConnection:
                        self.setupAlertAttributes(isError: true, alertMessage: "There is no internet connection, please check your connection")
                    default:
                        break
                    }
                }
            }, receiveValue: { [weak self] response in
                guard let self else { return }
                self.returnedCurrencies = response
                self.savedCurrenciesList = response
                startAutoRefresh()
            })
            .store(in: &cancelable)
    }

    /// Fetches search results from the API based on the search query.
    /// Displays a loading indicator while the search is in progress and updates `returnedCurrencies` with the search results.
    func getSearchCurrenciesListResults() {
        isLoading = true
        let requestModel = SearchListRequestModel(query: searchText)
        currenciesListUseCase.getSearchCurrenciesResults(requestModel: requestModel)
            .timeout(.seconds(10), scheduler: RunLoop.main)
            .sink(receiveCompletion: { [weak self] result in
                guard let self else { return }
                self.isLoading = false
                switch result {
                case .finished:
                    break
                case .failure(let err):
                    switch err {
                    case let .internalError(errorResponse):
                        self.setupAlertAttributes(isError: true, alertMessage: errorResponse.error ?? "")
                    case .unAuthorithed:
                        self.setupAlertAttributes(isError: true, alertMessage: "Something went wrong while fetching currencies")
                    case .noInternetConnection:
                        self.setupAlertAttributes(isError: true, alertMessage: "There is no internet connection, please check your connection")
                    default:
                        break
                    }
                }
            }, receiveValue: { [weak self] response in
                guard let self else { return }
                self.returnedCurrencies = response
            })
            .store(in: &cancelable)
    }
}
