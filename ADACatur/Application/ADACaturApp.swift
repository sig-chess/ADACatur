//
//  ADACaturApp.swift
//  ADACatur
//
//  Created by Ivan on 30/05/23.
//

import SwiftUI

@main
struct ADACaturApp: App {
    var body: some Scene {
        WindowGroup {
            // uncomment later
            // LoginScreen()
            
            // redirect to homeview when opening app (for development purpose)
            HomeView()
        }
    }
}
