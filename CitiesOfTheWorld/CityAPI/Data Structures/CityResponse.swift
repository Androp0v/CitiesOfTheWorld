//
//  CityResponse.swift
//  CitiesOfTheWorld
//
//  Created by Raúl Montón Pinillos on 15/11/21.
//

import Foundation

struct Country: Codable {
    let id: Int
    let name: String
    let code: String
    let created_at: String
    let updated_at: String
    let continent_id: Int
}

struct CityItem: Codable {
    let id: Int
    let name: String
    let local_name: String
    let lat: Double?
    let lng: Double?
    let created_at: String
    let updated_at: String
    let country_id: Int
    /// Country the city is at. Not always included, must be requested with an additional parameter in the request.
    let country: Country?
}

struct Pagination: Codable {
    let current_page: Int
    let last_page: Int
    let per_page: Int
    let total: Int
}

struct CityData: Codable {
    let items: [CityItem]
    let pagination: Pagination
}

class CityResponse: Codable {
    let data: CityData
    let time: Int
}
