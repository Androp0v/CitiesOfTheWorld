//
//  CityListRow.swift
//  CitiesOfTheWorld
//
//  Created by Raúl Montón Pinillos on 17/11/21.
//

import MapKit
import SwiftUI

struct CityListRow: View {
    
    let isSelected: Bool
    let cityItem: CityItem
    
    var body: some View {
        ZStack {
            if isSelected {
                Color(uiColor: .label)
                    .cornerRadius(8)
                    .opacity(0.1)
                    .edgesIgnoringSafeArea(.all)
            }
            Text(cityItem.name)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .listRowInsets(EdgeInsets())
        .contentShape(Rectangle())
    }
}

struct CityListRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            CityListRow(isSelected: false,
                        cityItem: CityItem(id: 0,
                                           name: "Kabul",
                                           local_name: "",
                                           lat: nil,
                                           lng: nil,
                                           created_at: "",
                                           updated_at: "",
                                           country_id: 0,
                                           country: nil))
        }
    }
}
