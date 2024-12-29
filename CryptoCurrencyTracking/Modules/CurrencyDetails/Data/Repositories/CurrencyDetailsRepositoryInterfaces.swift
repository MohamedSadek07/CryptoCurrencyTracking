//
//  CurrencyDetailsRepositoryInterfaces.swift
//  iJusoor
//
//  Created by Mohamed Sadek on 28/12/2024.
//

import Foundation
import Combine

protocol CurrencyDetailsRemoteRepositoryProtocol: AnyObject {
    func getCurrencyDetails(requestModel: CurrencyDetailsRequestModel) -> AnyPublisher<CurrencyDetailsResponseModel, NetworkError>
}
