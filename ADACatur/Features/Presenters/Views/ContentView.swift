//
//  ContentView.swift
//  ADACatur
//
//  Created by Ivan on 10/06/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var state: GlobalState
    
    var body: some View {
        NavigationView {
            LoginScreen()
                .environmentObject(state)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
