//
//  MapViewModel.swift
//  CitiesOfTheWorld
//
//  Created by Raúl Montón Pinillos on 17/11/21.
//

import Foundation
import MapKit

class MapViewModel: ObservableObject {
    // Default to Dublin for initial location of the MapView
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 53.3498, longitude: -6.2603),
                                               span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
}

// Extend MKCoordinateRegion to be able to initialize it directly from a CityItem
extension MKCoordinateRegion {
    init(cityItem: CityItem?) throws {
        guard let cityItem = cityItem else {
            throw MapError.noCityItem
        }
        guard let latitude = cityItem.lat else {
            throw MapError.latitudeOrLongitudeMissing
        }
        guard let longitude = cityItem.lng else {
            throw MapError.latitudeOrLongitudeMissing
        }
        self.init(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                  span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    }
}
