//
//  MainView.swift
//  CitiesOfTheWorld
//
//  Created by Raúl Montón Pinillos on 15/11/21.
//

import SwiftUI

struct MainView: View {
    
    /// Shared MapViewModel to the MapView and CityViews of the scene
    let mapViewModel = MapViewModel()
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
                
        if horizontalSizeClass == .compact {
            // iPhone or iPad SlideOver view, CityList shown modally via button tap
            NavigationView {
                MapView()
            }
            .environmentObject(mapViewModel)
        } else {
            // iPad and macOS Master-Detail view, CityList shown as sidebar
            NavigationView {
                CityListView()
                    .navigationTitle(NSLocalizedString("Cities of the World", comment: ""))
                    .navigationBarTitleDisplayMode(.inline)
                MapView()
            }
            .environmentObject(mapViewModel)
        }
    }
}

// MARK: - Previews
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
