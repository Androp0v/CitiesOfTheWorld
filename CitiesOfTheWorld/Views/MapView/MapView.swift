//
//  MapView.swift
//  CitiesOfTheWorld
//
//  Created by Raúl Montón Pinillos on 15/11/21.
//

import MapKit
import SwiftUI

struct MapView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var mapViewModel: MapViewModel
    @State private var showList = false

    var body: some View {
        ZStack(alignment: .bottom) {
            
            Map(coordinateRegion: $mapViewModel.region)
                .edgesIgnoringSafeArea(.all)
            
            // On iPhone, add an extra button to navigate to list view (there's no sidebar)
            if horizontalSizeClass == .compact {
                Button(action: {
                    showList.toggle()
                }, label: {
                    Text(NSLocalizedString("View city list", comment: ""))
                        .frame(maxWidth: .infinity)
                })
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .frame(maxWidth: .infinity)
                    .shadow(radius: 12)
                    .padding()
                    .sheet(isPresented: $showList) {
                        CityListViewSheet()
                    }
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
