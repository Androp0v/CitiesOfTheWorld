//
//  CityListViewModel.swift
//  CitiesOfTheWorld
//
//  Created by Raúl Montón Pinillos on 15/11/21.
//

import Foundation
import SwiftUI

class CityListViewModel: ObservableObject {
    
    // MARK: - Properties
    
    /// Displayed city names as displayed by the UI.
    @Published var cityItems: [CityItem] = []
    /// Page Loader actor to retrieve the page data from the API.
    var cityPageLoader = CityPageLoader()
    
    // MARK: - Initialization
    
    init() {
        // Load all cities by default
        Task {
            try? await loadInitialCities()
        }
    }
    
    // MARK: - Public functions
    
    /// Search city by name on the API and load the first page..
    /// - Parameter searchText: The search name text used as the input of the query.
    func searchCity(searchText: String) async throws {
        try await cityPageLoader.loadPage(page: 1, searchText: searchText, cityListViewModel: self)
    }
    
    /// Loads the next page if required.
    /// - Parameters:
    ///   - searchText: The search name text used as the input of the query.
    ///   - displayedRowIndex: The index of the list row that is calling this function.
    ///   - totalLoadedRows: The total number of rows in the view.
    func loadNextPageIfRequired(searchText: String, displayedRowIndex: Int, totalLoadedRows: Int) {
        Task {
            // Compute the current page
            guard let citiesPerPage = await cityPageLoader.pagination?.per_page else {
                return
            }
            let currentPage = Int( displayedRowIndex / citiesPerPage ) + 1
            
            // Load the next page
            try await cityPageLoader.loadPage(page: currentPage + 1, searchText: searchText, cityListViewModel: self)
        }
    }
    
    // MARK: - Private functions
    
    /// Loads the city list returned on an empty search query.
    private func loadInitialCities() async throws {
        try await cityPageLoader.loadPage(page: 1, searchText: "", cityListViewModel: self)
    }
}
