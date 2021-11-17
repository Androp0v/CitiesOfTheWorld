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
    case page = "page"
    case include = "include=country"
    case filterByName = "filter[0][name][contains]"
}
