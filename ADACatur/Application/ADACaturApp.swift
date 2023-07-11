//
//  ADACaturApp.swift
//  ADACatur
//
//  Created by Ivan on 30/05/23.
//

import SwiftUI
import CloudKit

class GlobalState: ObservableObject {
    
    let container: CKContainer
    
    @Published var playerRepository: PlayerRepository
    
    @Published var playerMatchRepository: PlayerMatchRepository
    
    @Published var matchRepository: MatchRepository
    
    init() {
        container = CKContainer.init(identifier: containerName)
        playerRepository = PlayerRepository(container: container)
        playerMatchRepository = PlayerMatchRepository(container: container)
        matchRepository = MatchRepository(container: container)
    }
}

@main
struct ADACaturApp: App {
    
    @StateObject var state = GlobalState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(state)
        }
    }
}
