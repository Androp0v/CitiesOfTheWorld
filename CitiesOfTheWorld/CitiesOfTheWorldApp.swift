//
//  CitiesOfTheWorldApp.swift
//  CitiesOfTheWorld
//
//  Created by Raúl Montón Pinillos on 15/11/21.
//

import SwiftUI

@main
struct CitiesOfTheWorldApp: App {
    
    var body: some Scene {
        WindowGroup {
            MainView()
                // Save CityAPI response cache to disk when the app is no longer active.
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    Task {
                        await CityAPI.shared.persistCache()
                    }
                }
        }
    }
}
