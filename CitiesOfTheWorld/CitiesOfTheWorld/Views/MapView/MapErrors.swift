//
//  MapErrors.swift
//  CitiesOfTheWorld
//
//  Created by Raúl Montón Pinillos on 17/11/21.
//

import Foundation

enum MapError: Error {
    case latitudeOrLongitudeMissing
    case noCityItem
}

extension MapError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .latitudeOrLongitudeMissing:
            return NSLocalizedString("Unable to show in map. There's no location data for the given city.", comment: "")
        case .noCityItem:
            return NSLocalizedString("Unknown error", comment: "")
        }
    }
}
