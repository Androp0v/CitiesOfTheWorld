//
//  CityAPIEndpoint.swift
//  CitiesOfTheWorld
//
//  Created by Raúl Montón Pinillos on 17/11/21.
//

import Foundation

enum CityAPIEndpoint: String {
    case api = "connect-demo.mobile1.io"
    case endpoint = "/square1/connect/v1/city"
}

enum CityAPIEndpointParameters: String {
    /// The page to be retrieved.
    case page = "page"
    /// Whether or not to include the country data.
    case include = "include"
    /// Parameter to filter the cities by name in the API.
    case filterByName = "filter[0][name][contains]"
}
