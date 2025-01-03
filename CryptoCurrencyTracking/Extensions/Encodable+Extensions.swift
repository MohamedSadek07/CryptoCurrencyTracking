//
//  Encodable+Extensions.swift
//  CryptoCurrencyTracking
//
//  Created by Mohamed Sadek on 25/12/2024.
//

import Foundation

// convert Encodable to the dictonary
extension Encodable {
    var asDictionary: [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else { return [:] }

        guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return [:]
        }
        return dictionary
    }
}
