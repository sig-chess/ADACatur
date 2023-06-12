//
//  PlayerViewModel.swift
//  ADACatur
//
//  Created by Ivan on 10/06/23.
//

import Foundation
import CloudKit
import AuthenticationServices

class PlayerRepository: ObservableObject {
    private var database: CKDatabase
    private var container: CKContainer
    
    init(container: CKContainer) {
        self.container = container
        self.database = self.container.publicCloudDatabase
    }

    func createPlayer(name: String, email: String, eloScore: Double) {
        let record = CKRecord(recordType: RecordType.player.rawValue)
        let player = Player(name: name, email: email)
        
        save(record: record)
    }
    
    func createPlayerViaAppleID(credentials: ASAuthorizationAppleIDCredential) {
        let record = CKRecord(recordType: RecordType.player.rawValue)
        let player = Player(credentials: credentials)
        
        record["name"] = player?.name
        record["email"] = player?.email
        record["eloScore"] = player?.eloScore
        record["appleUserId"] = player?.appleUserId
        
        save(record: record)
    }
    
    func save(record: CKRecord) {
        self.database.save(record) { newRecord, error in
            if let error = error {
                print(error)
            } else {
                print("Success to create record")
            }
        }
    }
}
