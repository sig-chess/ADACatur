//
//  ADACaturApp.swift
//  ADACatur
//
//  Created by Ivan on 30/05/23.
//

import SwiftUI
import CloudKit

struct CloudKitContainerKey: EnvironmentKey {
    static let defaultValue: CKContainer? = nil
}

extension EnvironmentValues {
    var cloudKitContainer: CKContainer? {
        get { self[CloudKitContainerKey.self] }
        set { self[CloudKitContainerKey.self] = newValue }
    }
}

@main
struct ADACaturApp: App {
    let container = CKContainer.init(identifier: containerName)
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.cloudKitContainer, container)
            
            RecordMatchView()
        }
    }
}
