//
//  CityAPICache.swift
//  CitiesOfTheWorld
//
//  Created by Raúl Montón Pinillos on 22/11/21.
//

import Foundation
import SwiftUI

class CityAPICache {
    
    // MARK: - Configuration
    
    /// Maximum number of CityResponses that will be persisted to disk.
    let maxNumberOfPersistedResponses: Int = 10
    
    // MARK: - Properties
    
    /// NSCache with the latest responses fetched from the API.
    private var cache = NSCache<NSString, CityResponse>()
    /// A list with the latest responses to be cached to disk.
    private var persistedCachedResponses = [CachedCityResponse]()
    
    /// A little structure to hold both the response and the URL request.
    private struct CachedCityResponse: Codable {
        let url: URL
        let response: CityResponse
        
        init(url: URL, response: CityResponse) {
            self.url = url
            self.response = response
        }
    }
    
    // MARK: - Initialization
    
    init() {
        loadFromDisk()
    }
    
    // MARK: - NSCache write/read
    
    /// Try to get URL from local cache (if present).
    /// - Parameter url: URL of the API request.
    /// - Returns: The response object.
    func getCachedResponse(url: URL) -> CityResponse? {
        let urlString = url.absoluteString as NSString
        return self.cache.object(forKey: urlString)
    }
    
    /// Save response to local cache.
    /// - Parameters:
    ///   - url: URL of the API request.
    ///   - cityResponse: The response object.
    func writeResponseToCache(url: URL, cityResponse: CityResponse) {
        let urlString = url.absoluteString as NSString
        self.cache.setObject(cityResponse, forKey: urlString)
        updatePersistedResponses(cachedCityResponse: CachedCityResponse(url: url, response: cityResponse))
    }
    
    // MARK: - Disk persistency
    
    /// Load persistently saved responses from disk.
    func loadFromDisk() {
        let fileManager = FileManager.default
        guard let folderURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = folderURL.appendingPathComponent("CityAPI.cache")
        guard let data = try? Data(contentsOf: fileURL) else {
            return
        }
        guard let persistedResponses = try? JSONDecoder().decode([CachedCityResponse].self, from: data) else {
            return
        }
        // Add disk-persisted response to the newly created cache
        persistedResponses.forEach { persistedResponse in
            let urlString = persistedResponse.url.absoluteString as NSString
            self.cache.setObject(persistedResponse.response, forKey: urlString)
        }
        self.persistedCachedResponses = persistedResponses
    }
    
    /// Write the last maxNumberOfPersistedResponses to disk.
    func writeToDisk() {
        let fileManager = FileManager.default
        guard let folderURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = folderURL.appendingPathComponent("CityAPI.cache")
        guard let data = try? JSONEncoder().encode(self.persistedCachedResponses) else {
            return
        }
        try? data.write(to: fileURL)
    }
    
    // MARK: - Private methods
    
    /// Update the local list with the CachedCityResponse objects to persist, taking into account the maximum
    /// number of persisted objects defined in the class.
    private func updatePersistedResponses(cachedCityResponse: CachedCityResponse) {
        if persistedCachedResponses.count < maxNumberOfPersistedResponses {
            persistedCachedResponses.append(cachedCityResponse)
        } else {
            persistedCachedResponses.insert(cachedCityResponse, at: 0)
            persistedCachedResponses.removeLast()
        }
    }
    
}
