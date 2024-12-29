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
    private let coordinator: CurrenciesCoordinatorProtocol
    private var cancelable: Set<AnyCancellable> = []
    private var shouldAutoRefresh = true
    private var isSearching = false
    private var savedCurrenciesList: [CurrencyModelItem] = []
    private var savedSearchCurrenciesList: [CurrencyModelItem] = []
    var title = "Currencies"
    var alertTitle = ""
    var alertMessage = ""
    //MARK: Published Variables
    @Published var searchText: String = ""
    @Published var returnedCurrencies: [CurrencyModelItem] = []
    @Published var filteredItems: [CurrencyModelItem] = []
    @Published var showAlert = false
    @Published var isLoading = false
    @Published var refreshTrigger = PassthroughSubject<Void, Never>()
    @Published var isFavorited: Bool = false
    //MARK: - Init
    init(currenciesListUseCase: CurrenciesListUseCaseProtocol,
         coordinator: CurrenciesCoordinatorProtocol) {
        self.currenciesListUseCase = currenciesListUseCase
        self.coordinator = coordinator
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

    /// Setup Timer in order to handle autoRefresh every 30 seconds
    func setupAutoRefresh() {
        Timer.publish(every: 30, on: .main, in: .common)
            .autoconnect()
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
                    isSearching = false
                    self.returnedCurrencies = self.savedCurrenciesList
                    startAutoRefresh()
                } else {
                    isSearching = true
                    stopAutoRefresh()
                    getSearchCurrenciesListResults()
                }
            }
            .store(in: &cancelable)
    }
    /// Starts the auto-refresh mechanism by enabling it and sending a refresh trigger.
    private func startAutoRefresh() {
        shouldAutoRefresh = true
    }

    /// Stops the auto-refresh mechanism by disabling it.
    private func stopAutoRefresh() {
        shouldAutoRefresh = false
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
                case .failure(let error):
                    errorReporting(error: error)
                }
            }, receiveValue: { [weak self] response in
                guard let self else { return }
                self.returnedCurrencies = response
                self.savedCurrenciesList = response
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
                case .failure(let error):
                    errorReporting(error: error)
                }
            }, receiveValue: { [weak self] response in
                guard let self else { return }
                self.returnedCurrencies = response
                self.savedSearchCurrenciesList = response
            })
            .store(in: &cancelable)
    }

    /// Handles the action of adding or removing a currency item from favorites
    func handleFavoriteAction(_ isFavorite: Bool, _ item: CurrencyModelItem) {
        if isFavorite {
            currenciesListUseCase.addFavorite(item)
        } else {
            currenciesListUseCase.removeFavorite(item)
        }

        // Check isSearching to check whether to apply to searchResults or allResults
        if isSearching {
            // Updating Search List
            if let index = savedSearchCurrenciesList.firstIndex(where: { $0.id == item.id }) {
                savedSearchCurrenciesList[index].isFavorite.toggle()
            }
            self.returnedCurrencies = savedSearchCurrenciesList
            // Updating Saved whole list
            if let index = savedCurrenciesList.firstIndex(where: { $0.id == item.id }) {
                savedCurrenciesList[index].isFavorite.toggle()
            }
        } else  {
            if let index = savedCurrenciesList.firstIndex(where: { $0.id == item.id }) {
                savedCurrenciesList[index].isFavorite.toggle()
            }
            self.returnedCurrencies = savedCurrenciesList
        }
    }

    /// Toggles the favorites view when the favorites button is tapped.
    func favoritesButtonTapped() {
        isFavorited.toggle()
        if isFavorited {
            stopAutoRefresh()
            returnedCurrencies = currenciesListUseCase.getFavorites()
        } else {
            startAutoRefresh()
            returnedCurrencies = savedCurrenciesList
        }
    }

    /// Trigger navigation to currency details
    func didSelectCurrency(with id: String) {
        coordinator.push(page: .currencyDetail(currencyID: id))
    }

    /// StopAutoRefresh, reset refreshTrigger and remove all cancellables
    func removeAllSubscribers() {
        stopAutoRefresh()
        cancelable.removeAll()
    }
}
