//
//  CitySightsApp.swift
//  City Sights
//
//  Created by Semih Cetin on 28.09.2022.
//

import SwiftUI

@main
struct CitySightsApp: App {
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(ContentModel())
        }
    }
}
