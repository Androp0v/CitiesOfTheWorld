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
            VStack(spacing: 2) {
                Text(cityItem.name)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if let countryName = cityItem.country?.name {
                    Text(countryName)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                }
            }
            .padding(.vertical, 8)
        }
        .listRowInsets(EdgeInsets())
        .contentShape(Rectangle())
    }
}

struct CityListRow_Previews: PreviewProvider {
    static var previews: some View {
        
        let country = Country(id: 0,
                              name: "Korea",
                              code: "",
                              created_at: "",
                              updated_at: "",
                              continent_id: 0)
        List {
            CityListRow(isSelected: false,
                        cityItem: CityItem(id: 0,
                                           name: "Seoul",
                                           local_name: "",
                                           lat: nil,
                                           lng: nil,
                                           created_at: "",
                                           updated_at: "",
                                           country_id: 0,
                                           country: country))
        }
    }
}
