//
//  CityAPIErrors.swift
//  CitiesOfTheWorld
//
//  Created by Raúl Montón Pinillos on 16/11/21.
//

import Foundation

enum CityAPIError: Error {
    /// The request URL couldn't be constructed.
    case malformedURL
    /// Unable to parse the response from the API.
    case invalidResponseData
    /// The HTTP Response from the API has an unsuccessful status code.
    case apiError
    /// Unknown error.
    case unknown
}

// Localized descriptions for API errors could be built here
extension CityAPIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        // case .malformedURL: ...
        // case .invalidResponseData: ...
        // case .apiError: ...
        default: return NSLocalizedString("Unknown error", comment: "")
        }
    }
}
