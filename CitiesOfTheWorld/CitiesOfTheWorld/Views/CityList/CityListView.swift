//
//  ListView.swift
//  CitiesOfTheWorld
//
//  Created by Raúl Montón Pinillos on 15/11/21.
//

import MapKit
import SwiftUI

struct CityListView: View {
    
    // MARK: - Properties
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var mapViewModel: MapViewModel
    @StateObject var viewModel = CityListViewModel()
    @State private var searchText: String = ""
    @State private var selectedRow: Int?
    
    // Use alerts to display errors to the user
    
    @State var showAlert: Bool = false
    @State var alertText: String = ""
    
    func showAlert(text: String) {
        DispatchQueue.main.async {
            self.alertText = text
            self.showAlert = true
        }
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack(alignment: .top) {
            List {
                ForEach(Array(zip(viewModel.cityItems.indices, viewModel.cityItems)), id: \.0) { rowIndex, cityItem in
                    CityListRow(isSelected: rowIndex == selectedRow, cityItem: cityItem)
                        .onAppear {
                            viewModel.loadNextPageIfRequired(searchText: searchText,
                                                             displayedRowIndex: rowIndex,
                                                             totalLoadedRows: viewModel.cityItems.count)
                        }
                        .onTapGesture {
                            do {
                                mapViewModel.region = try MKCoordinateRegion(cityItem: cityItem)
                                selectedRow = rowIndex
                                dismiss()
                            } catch let error as MapError {
                                showAlert(text: error.localizedDescription)
                            } catch let error {
                                showAlert(text: error.localizedDescription)
                            }
                        }
                }
            }
            // Make view searchable
            .searchable(text: $searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: NSLocalizedString("Search city", comment: ""))
            // Use onChange only to detect the search box being cleared
            .onChange(of: searchText) { newText in
                if newText.isEmpty {
                    // TO-DO:
                    print("Search cleared!")
                }
            }
            // Only make queries when the submit button is pressed
            .onSubmit(of: .search) {
                Task {
                    do {
                        try await viewModel.searchCity(searchText: searchText)
                    } catch let error {
                        showAlert(text: error.localizedDescription)
                    }
                }
            }
            // Display alerts when data fetching fails
            .alert(alertText, isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            }
        }
    }
}

// MARK: - Wrap as sheet
struct CityListViewSheet: View {
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            CityListView()
                .navigationTitle(NSLocalizedString("Cities", comment: ""))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        },
                               label: {
                            Text(NSLocalizedString("Close", comment: ""))
                        })
                    }
                }
        }
    }
    
}

// MARK: - Previews

struct CityListView_Previews: PreviewProvider {
    static var previews: some View {
        CityListView()
    }
}
