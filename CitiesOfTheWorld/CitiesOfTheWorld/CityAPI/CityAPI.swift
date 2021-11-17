//
//  CityAPI.swift
//  CitiesOfTheWorld
//
//  Created by Raúl Montón Pinillos on 15/11/21.
//

import Foundation

actor CityAPI {
    
    // MARK: - Properties
    private var cachedResponses = NSCache<NSString, CityResponse>()
    
    // MARK: - Initialization
    static let shared = CityAPI()
    private init() { }
    
    // MARK: - Public functions
    
    /// Retrieve the city data for a given search from either local cache or a network request.
    /// - Parameter searchText: Search query.
    /// - Returns: CityAPI Response.
    func retrieveCityData(searchText: String, page: Int) async throws -> CityResponse {
        
        // Construct the URL
        var components = URLComponents()
        components.scheme = "https"
        components.host = CityAPIEndpoint.api.rawValue
        components.path = CityAPIEndpoint.endpoint.rawValue
        components.queryItems = []
        if !searchText.isEmpty {
            components.queryItems?.append(URLQueryItem(name: CityAPIEndpointParameters.filterByName.rawValue,
                                                       value: searchText))
        }
        components.queryItems?.append(URLQueryItem(name: CityAPIEndpointParameters.page.rawValue,
                                                   value: String(page)))

        guard let url = components.url else {
            throw CityAPIError.malformedURL
        }
        
        // Try to retrieve from local cache first
        if let locallyCachedData = getFromLocalCache(url: url) {
            return locallyCachedData
        }
        
        // Construct the request
        let urlRequest = URLRequest(url: url)
        
        // Await the response from the API
        let (responseData, response) = try await URLSession.shared.data(for: urlRequest)

        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw CityAPIError.unknown
        }
        guard statusCode >= 200 && statusCode <= 299 else {
            throw CityAPIError.apiError
        }
                
        // Parse the data
        do {
            let cityResponse = try JSONDecoder().decode(CityResponse.self, from: responseData)
            writeToLocalCache(url: url, cityResponse: cityResponse)
            return cityResponse
        } catch {
            throw CityAPIError.invalidResponseData
        }
    }
    
    // MARK: - Caching
        
    private func getFromLocalCache(url: URL) -> CityResponse? {
        let urlString = url.absoluteString as NSString
        return self.cachedResponses.object(forKey: urlString)
    }
    
    private func writeToLocalCache(url: URL, cityResponse: CityResponse) {
        let urlString = url.absoluteString as NSString
        self.cachedResponses.setObject(cityResponse, forKey: urlString)
    }
    
}
