//
//  CurrenciesListViewModelTests.swift
//  CurrenciesListViewModelTests
//
//  Created by Mohamed Sadek on 25/12/2024.
//

import XCTest
import Combine
@testable import CryptoCurrencyTracking

class CurrenciesListViewModelTests: XCTestCase {
    // MARK: - Variables
    private var viewModel: CurrenciesListViewModel!
    private var mockUseCase: MockCurrenciesListUseCase!
    private var mockCoordinator: MockCurrenciesCoordinator!
    private var cancellables: Set<AnyCancellable>!

    // MARK: - Setup and Teardown
    override func setUp() {
        super.setUp()
        mockUseCase = MockCurrenciesListUseCase()
        mockCoordinator = MockCurrenciesCoordinator()
        viewModel = CurrenciesListViewModel(currenciesListUseCase: mockUseCase, coordinator: mockCoordinator)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        mockCoordinator = nil
        cancellables = nil
        super.tearDown()
    }

    // MARK: - Tests
    func testInitialState() {
        XCTAssertEqual(viewModel.title, "Currencies")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.showAlert)
        XCTAssertFalse(viewModel.isFavorited)
        XCTAssertTrue(viewModel.returnedCurrencies.isEmpty)
        XCTAssertTrue(viewModel.filteredItems.isEmpty)
        XCTAssertEqual(viewModel.alertTitle, "")
        XCTAssertEqual(viewModel.alertMessage, "")
    }

    func testSetupAlertAttributes_Error() {
        // Arrange
        let expectation = expectation(description: "Wait for alert attributes to be updated")

        // Act
        viewModel.setupAlertAttributes(isError: true, alertMessage: "Test Error")

        // Assert
        DispatchQueue.main.async {
            XCTAssertTrue(self.viewModel.showAlert, "Show alert should be true")
            XCTAssertEqual(self.viewModel.alertTitle, "Error", "Alert title should be 'Error'")
            XCTAssertEqual(self.viewModel.alertMessage, "Test Error", "Alert message should match the provided value")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }



    func testSetupAlertAttributes_Success() {
        // Arrange
        let expectation = XCTestExpectation(description: "Wait for alert attributes to be updated")

        // Act
        viewModel.setupAlertAttributes(isError: false, alertMessage: "Success Message")

        // Assert
        DispatchQueue.main.async {
            XCTAssertTrue(self.viewModel.showAlert, "Expected 'showAlert' to be true")
            XCTAssertEqual(self.viewModel.alertTitle, "Success", "Expected 'alertTitle' to be 'Success'")
            XCTAssertEqual(self.viewModel.alertMessage, "Success Message", "Expected 'alertMessage' to be 'Success Message'")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }


    func testGetCurrenciesList_Success() {
        // Arrange
        mockUseCase.mockCurrenciesList = [CurrencyModelItem(id: "bitcoin", name: "Bitcoin")]

        // Act
        viewModel.getCurrenciesList()

        // Assert
        XCTAssertTrue(viewModel.isLoading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertEqual(self.viewModel.returnedCurrencies.count, 1)
            XCTAssertEqual(self.viewModel.returnedCurrencies.first?.id, "bitcoin")
        }
    }

    func testGetCurrenciesList_Failure() {
        // Arrange
        mockUseCase.shouldFail = true

        // Act
        viewModel.getCurrenciesList()

        // Assert
        XCTAssertTrue(viewModel.isLoading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertTrue(self.viewModel.showAlert)
            XCTAssertEqual(self.viewModel.alertTitle, "Error")
        }
    }

    func testGetSearchCurrenciesListResults() {
        // Arrange
        viewModel.searchText = "btc"
        mockUseCase.mockSearchCurrenciesList = [CurrencyModelItem(id: "bitcoin", name: "Bitcoin")]

        // Act
        viewModel.getSearchCurrenciesListResults()

        // Assert
        XCTAssertTrue(viewModel.isLoading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertEqual(self.viewModel.returnedCurrencies.count, 1)
            XCTAssertEqual(self.viewModel.returnedCurrencies.first?.id, "bitcoin")
        }
    }

    func testHandleFavoriteAction_AddFavorite() {
        // Arrange
        let item = CurrencyModelItem(id: "bitcoin", name: "Bitcoin", isFavorite: false)
        viewModel.savedCurrenciesList = [item]

        // Act
        viewModel.handleFavoriteAction(true, item)

        // Assert
        XCTAssertTrue(mockUseCase.addFavoriteCalled, "addFavorite method in the use case should have been called")
        XCTAssertTrue(viewModel.savedCurrenciesList.first?.isFavorite ?? false, "The item's 'isFavorite' property should be true")
    }


    func testHandleFavoriteAction_RemoveFavorite() {
        // Arrange
        let item = CurrencyModelItem(id: "bitcoin", name: "Bitcoin", isFavorite: true)
        viewModel.savedCurrenciesList = [item] // Ensure the item is in the list

        // Act
        viewModel.handleFavoriteAction(false, item)

        // Assert
        XCTAssertTrue(mockUseCase.removeFavoriteCalled, "Remove favorite should be called")
        XCTAssertFalse(viewModel.savedCurrenciesList.first?.isFavorite ?? true, "The item should no longer be marked as favorite")
    }


    func testFavoritesButtonTapped() {
        // Act
        viewModel.favoritesButtonTapped()

        // Assert
        XCTAssertTrue(viewModel.isFavorited)
        XCTAssertEqual(viewModel.returnedCurrencies, mockUseCase.mockFavorites)
    }

    func testDidSelectCurrency() {
        // Act
        viewModel.didSelectCurrency(with: "bitcoin")

        // Assert
        XCTAssertTrue(mockCoordinator.pushCalled)
        XCTAssertEqual(mockCoordinator.lastPushedID, "bitcoin")
    }
}

// MARK: - Mocks
class MockCurrenciesListUseCase: CurrenciesListUseCaseProtocol {
    var mockCurrenciesList: [CurrencyModelItem] = []
    var mockSearchCurrenciesList: [CurrencyModelItem] = []
    var mockFavorites: [CurrencyModelItem] = []
    var shouldFail = false

    var addFavoriteCalled = false
    var removeFavoriteCalled = false

    func fetchCurrenciesList(requestModel: CurrenciesListRequestModel) -> AnyPublisher<[CurrencyModelItem], NetworkError> {
        if shouldFail {
            return Fail(error: NetworkError.internalError(NetworkErrorResponse(error: "Failed to fetch data")))
                .eraseToAnyPublisher()
        }
        return Just(mockCurrenciesList)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }

    func getSearchCurrenciesResults(requestModel: SearchListRequestModel) -> AnyPublisher<[CurrencyModelItem], NetworkError> {
        return Just(mockSearchCurrenciesList)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }

    func addFavorite(_ item: CurrencyModelItem) {
        addFavoriteCalled = true
    }

    func removeFavorite(_ item: CurrencyModelItem) {
        removeFavoriteCalled = true
    }

    func getFavorites() -> [CurrencyModelItem] {
        return mockFavorites
    }
}

class MockCurrenciesCoordinator: CurrenciesCoordinatorProtocol {
    var pushCalled = false
    var lastPushedID: String?
    var popCalled = false
    var popToRootCalled = false

    func push(page: CurrencyNavigationDestination) {
        pushCalled = true
        if case let .currencyDetail(currencyID) = page {
            lastPushedID = currencyID
        }
    }

    func pop() {
        popCalled = true
    }

    func popToRoot() {
        popToRootCalled = true
    }
}

