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
    var cityPageLoader = CityPageLoader()
    
    // MARK: - Initialization
    
    init() {
        // Load all cities by default
        Task {
            try? await loadInitialCities()
        }
    }
    
    // MARK: - Public functions
    
    func searchCity(searchText: String) async throws {
        try await cityPageLoader.loadPage(page: 1, searchText: searchText, cityListViewModel: self)
    }
    
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
    
    private func loadInitialCities() async throws {
        try await cityPageLoader.loadPage(page: 1, searchText: "", cityListViewModel: self)
    }
}
