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
    
    @Published var player: Player?
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
        Task {
            await save(record: record)
        }
    }
    
    func createPlayerViaAppleID(credentials: ASAuthorizationAppleIDCredential) {
       
        Task {
            let record = CKRecord(recordType: RecordType.player.rawValue)
            let player = Player(credentials: credentials)
            
            record["name"] = player?.name
            record["email"] = player?.email
            record["eloScore"] = player?.eloScore
            record["appleUserId"] = player?.appleUserId
            await save(record: record)
        }
        
    }
    
    func fetchUser(appleUserId: String) async {
        
        let predicate = NSPredicate(format: "appleUserId == %@", appleUserId)
        let query = CKQuery(recordType: RecordType.player.rawValue, predicate: predicate)
        
        do {
            let records = try await database.perform(query, inZoneWith: nil)
            
            let firstRecord = records.first
            player = Player(recordId: firstRecord?.recordID, name: firstRecord!["name"] as! String, email: firstRecord!["email"] as! String, eloScore: firstRecord!["eloScore"] as! Double)
        } catch let error {
            print(error)
        }
    }
    
    func fetchAllUser() async {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: RecordType.player.rawValue, predicate: predicate)
        // TODO: uncomment once we want to sort this
        query.sortDescriptors = [NSSortDescriptor(key: "eloScore", ascending: false)]
        do {
            let records = try await database.perform(query, inZoneWith: nil)
            let models = records.map { record in
                Player(recordId: record.recordID, name: record["name"] as? String ?? "", email: record["email"] as? String ?? "", eloScore: record["eloScore"] as? Double ?? 0.0)
            }
            DispatchQueue.main.async { [weak self] in
                self?.allPlayers = models
            }
            
            print(self.allPlayers)
            
            print(self.allPlayers)
        } catch let error {
            print(error)
        }
    }
    
    
    
    func updateElo(player: Player, eloChange: Double) async{
        do {
            let record1 = try await database.record(for: player.recordId!)
            record1["eloScore"] = eloChange
            await self.save(record: record1)
        } catch let error {
            print(error)
        }
    }
    
    func save(record: CKRecord) async {
        do {
            let newRecord = try await self.database.save(record)
            print("Success to create record")
        } catch let error {
            print(error)
        }
    }
}
