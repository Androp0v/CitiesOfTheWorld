//
//  CityPageLoader.swift
//  CitiesOfTheWorld
//
//  Created by Raúl Montón Pinillos on 17/11/21.
//

import Foundation
import SwiftUI

/// Class to synchronize city page loading in a CityListViewModel.
actor CityPageLoader {
    
    // MARK: - Properties
    
    /// Pagination object.
    var pagination: Pagination?
    
    /// Whether the actor is currently loading a page.
    private var isLoadingPage: Bool = false
    /// The last page loaded. Both 0 and 1 pages are the same.
    private var lastLoadedPage: Int = 0
    /// Current search query.
    private var currentSearchQuery: String = ""
    /// Actor model prevents reading while writing, but doesn't prevent WAR data hazards on loadPage's check of isLoadingPage.
    private var serialLock = NSLock()
    
    // MARK: - Page loading
    
    /// Load a new page from data source and add it to the UI.
    /// - Parameters:
    ///   - page: The page that should be loaded.
    ///   - searchText: The search text, used to verify that the page being loaded belongs to the same query.
    ///   - cityListViewModel: The ViewModel containing the source data used by the UI.
    func loadPage(page: Int, searchText: String, cityListViewModel: CityListViewModel) async throws {
        
        serialLock.lock()
        
        if isCurrentQuery(searchText: searchText) {
            // Avoid loading the same page twice
            guard !isLoadingPage else {
                serialLock.unlock()
                return
            }
            // Avoid loading pages that have been loaded before or skipping pages
            guard page == lastLoadedPage + 1 else {
                serialLock.unlock()
                return
            }
            // Avoid trying to load pages beyond the last page
            if let lastPage = pagination?.last_page {
                guard page <= lastPage else {
                    serialLock.unlock()
                    return
                }
            }
        } else {
            lastLoadedPage = 0
            currentSearchQuery = searchText
            clearItems(cityListViewModel: cityListViewModel)
        }
        
        // Mark as loading to avoid future calls trying to load the same page.
        isLoadingPage = true
        
        serialLock.unlock()
        
        // Load the next page
        let cityResponse = try await CityAPI.shared.retrieveCityData(searchText: searchText,
                                                                     page: page)
        
        // Ensure the query hasn't changed after the suspension
        guard searchText == currentSearchQuery else {
            return
        }
        
        // Mark as loaded and add the rows on the main thread
        isLoadingPage = false
        lastLoadedPage += 1
        
        // Use the retrieved data
        pagination = cityResponse.data.pagination
        addNewItemsToList(items: cityResponse.data.items,
                          cityListViewModel: cityListViewModel,
                          shouldClearList: false)
    }
    
    // MARK: - UI updates
    
    /// Adds additional rows to the existing data on a given CityListViewModel.
    /// - Parameters:
    ///   - items: The items to add.
    ///   - cityListViewModel: The city list view model object.
    ///   - shouldClearList: Whether the existing data on the city list view model should be deleted before adding the new rows.
    func addNewItemsToList(items: [CityItem], cityListViewModel: CityListViewModel, shouldClearList: Bool) {
        DispatchQueue.main.sync {
            // Clear the list if required
            if shouldClearList {
                clearItems(cityListViewModel: cityListViewModel)
            }
            // Add the new query results
            for cityItem in items {
                cityListViewModel.cityItems.append(cityItem)
            }
        }
    }
    
    // MARK: - Private methods
    
    /// Checks if the search query being handled matches the current search query of the CityPageLoader actor.
    /// - Parameter searchText: The search query.
    /// - Returns: True, if the queries match, false otherwise.
    private func isCurrentQuery(searchText: String) -> Bool {
        return searchText == currentSearchQuery
    }
    
    /// Deletes all rows from the view model of the city list.
    /// - Parameter cityListViewModel: The city list view model object.
    private nonisolated func clearItems(cityListViewModel: CityListViewModel) {
        DispatchQueue.main.sync {
            cityListViewModel.cityItems = []
        }
    }
}
