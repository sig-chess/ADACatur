//
//  PlayerViewModel.swift
//  ADACatur
//
//  Created by Ivan on 10/06/23.
//

import Foundation
import CloudKit
import AuthenticationServices

import SwiftUI

class PlayerRepository: ObservableObject {
    private var database: CKDatabase
    private var container: CKContainer
    
    @Published var player: Player = Player(name: "", email: "")
    @Published var allPlayers: [Player] = []
    
    
    init(container: CKContainer) {
        self.container = container
        self.database = self.container.publicCloudDatabase
        Task {
            await fetchAllUser()
        }
        
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
    
    func fetchUser(appleUserId: String) async -> Player {
        
        let predicate = NSPredicate(format: "appleUserId == %@", appleUserId)
        let query = CKQuery(recordType: RecordType.player.rawValue, predicate: predicate)
        
        
        do {
            let records = try await database.perform(query, inZoneWith: nil)
            let firstRecord = records.first
            player = Player(recordId: firstRecord?.recordID, name: firstRecord!["name"] as! String, email: firstRecord!["email"] as! String, eloScore: firstRecord!["eloScore"] as! Double)
            return player
        } catch let error {
            print(error)
        }
        
        return Player(name: "", email: "")
    }
    
    func fetchAllUser() async -> [Player]{
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: RecordType.player.rawValue, predicate: predicate)
        // TODO: uncomment once we want to sort this
        query.sortDescriptors = [NSSortDescriptor(key: "eloScore", ascending: true)]
        do {
            let records = try await database.perform(query, inZoneWith: nil)
            let models = records.map { record in
                Player(recordId: record.recordID, name: record["name"] as? String ?? "", email: record["email"] as? String ?? "", eloScore: record["eloScore"] as? Double ?? 0.0)
            }
            self.allPlayers = models
            return models
        } catch let error {
            print(error)
        }
        return []
    }
    
    func addOperation(operation: CKDatabaseOperation) {
        database.add(operation)
    }
    
    func updateElo(player: Player, eloChange: Double){
        database.fetch(withRecordID: player.recordId!) { record, error in
            if let error = error {
                print(error)
            }else {
                record!["eloScore"] = eloChange
                self.save(record: record!)
                Task {
                    await self.fetchAllUser()
                }
            }

        }
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
