//
//  CurrencyDetailsViewModelTests.swift
//  CryptoCurrencyTrackingTests
//
//  Created by Mohamed Sadek on 29/12/2024.
//

import XCTest
import Combine
@testable import CryptoCurrencyTracking

class CurrencyDetailsViewModelTests: XCTestCase {
    // MARK: Variables
    private var viewModel: CurrencyDetailsViewModel!
    private var mockUseCase: MockCurrencyDetailsUseCase!
    private var cancellables: Set<AnyCancellable>!

    // MARK: - Methods
    /// Setup
    override func setUp() {
        super.setUp()
        mockUseCase = MockCurrencyDetailsUseCase()
        viewModel = CurrencyDetailsViewModel(currencyDetailsUseCase: mockUseCase, currencyID: "testID")
        cancellables = []
    }

    /// tearDown
    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        cancellables = nil
        super.tearDown()
    }

    /// Test Intial State of viewModel
    func testInitialState() {
        XCTAssertEqual(viewModel.sentCurrencyID, "testID")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertTitle, "")
        XCTAssertEqual(viewModel.alertMessage, "")
        XCTAssertEqual(viewModel.currencyDetails, CurrencyModelItem())
    }

    /// Test Intial State of viewModel
    func test_WhenSetErrorAlert_ThenAlertAttributesShouldBeSet() {
        // Arrange
           let expectation = XCTestExpectation(description: "Wait for alert attributes to be set")

           // Act
           viewModel.setupAlertAttributes(isError: true, alertMessage: "Test Error")

           // Assert
           DispatchQueue.main.async {
               XCTAssertTrue(self.viewModel.showAlert, "Show alert should be true")
               XCTAssertEqual(self.viewModel.alertTitle, "Error", "Alert title should be 'Error'")
               XCTAssertEqual(self.viewModel.alertMessage, "Test Error", "Alert message should match the provided value")
               expectation.fulfill()
           }

           // Wait for the expectation
           wait(for: [expectation], timeout: 1.0)
    }

    /// Test Alert Success Case
    func test_WhenSetSuccessAlert_ThenAlertAttributesShouldBeSet() {
        // Arrange
           let expectation = XCTestExpectation(description: "Wait for alert attributes to be set")

           // Act
           viewModel.setupAlertAttributes(isError: false, alertMessage: "Success Alert")

           // Assert
           DispatchQueue.main.async {
               XCTAssertTrue(self.viewModel.showAlert, "Show alert should be false")
               XCTAssertEqual(self.viewModel.alertTitle, "Success", "Alert title should be 'Error'")
               XCTAssertEqual(self.viewModel.alertMessage, "Success Alert", "Alert message should match the provided value")
               expectation.fulfill()
           }

           // Wait for the expectation
           wait(for: [expectation], timeout: 1.0)
    }

    /// Test Alert Error Case
    func test_WhenCallingDetailsAPi_ThenShouldGetResponse() {
        // Given
        let viewModel = CurrencyDetailsViewModel(currencyDetailsUseCase: mockUseCase, currencyID: "testID")
        let expectation = expectation(description: "Data fetched and decoded successfully")

        // When
        viewModel.getCurrencyDetails()

        // Then
        DispatchQueue.main.async {
            let data = viewModel.currencyDetails
            if data != CurrencyModelItem() {
                XCTAssertNotNil(data, "Data should not be nil")
                XCTAssertEqual(data.id, "bitcoin", "The id should match the mock id")
                XCTAssertEqual(data.name, "Bitcoin", "The name should match the mock title")
                XCTAssertEqual(data.symbol, "btc", "The symbol should match the mock symbol")
                XCTAssertEqual(data.image, "", "The image should match the mock image")
                XCTAssertEqual(data.currentPrice, 94.99, "The currentPrice should match the mock currentPrice")
                XCTAssertEqual(data.isFavorite, false, "The isFavorite should match the mock isFavorite")
                expectation.fulfill()
            } else {
                XCTFail("Failed to fetch data")
            }
        }
        waitForExpectations(timeout: 3)
    }
}

/// Mocking CurrenyDetails API Request
class MockCurrencyDetailsUseCase: CurrencyDetailsUseCaseProtocol {
    var result: Result<CurrencyModelItem, NetworkError>?

    func getCurrencyDetails(requestModel: CurrencyDetailsRequestModel) -> AnyPublisher<CurrencyModelItem, NetworkError> {
        let data = CurrencyModelItem(id: "bitcoin", name: "Bitcoin", symbol: "btc", image: "", currentPrice: 94.99, isFavorite: false)
        return Just(data)
               .setFailureType(to: NetworkError.self)
               .eraseToAnyPublisher()
    }
}
