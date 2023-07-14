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

class PlayerRepository {
    private var database: CKDatabase
    private var container: CKContainer
    
    init(container: CKContainer) {
        self.container = container
        self.database = self.container.publicCloudDatabase
        
    }
    
    func createPlayerViaAppleID(credentials: ASAuthorizationAppleIDCredential, completion: @escaping (_ status: Bool, _ error: Error?) -> Void) {
        Task {
            do {
                let record = CKRecord(recordType: RecordType.player.rawValue)
                let player = Player(credentials: credentials)
                if player?.name == "" {
                    completion(true, nil)
                }
                else {
                    record["name"] = player?.name
                    record["email"] = player?.email
                    record["eloScore"] = player?.eloScore
                    record["appleUserId"] = player?.appleUserId
                    try await save(record: record)
                    completion(true, nil)
                }
                
               
            } catch {
                completion(false, error)
            }
        }
    }
    
    func fetchUser(appleUserId: String) async -> Player? {
        
        let predicate = NSPredicate(format: "appleUserId == %@", appleUserId)
        let query = CKQuery(recordType: RecordType.player.rawValue, predicate: predicate)
        
        do {
            let records = try await database.perform(query, inZoneWith: nil)
            let firstRecord = records.first
            return Player(recordId: firstRecord?.recordID, name: firstRecord?["name"] as? String ?? "", email: firstRecord?["email"] as? String ?? "", eloScore: firstRecord?["eloScore"] as? Double ?? 600)
        } catch let error {
            print(error)
        }
        return nil
    }
    
    func fetchAllUser() async -> [Player] {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: RecordType.player.rawValue, predicate: predicate)
        // TODO: uncomment once we want to sort this
        query.sortDescriptors = [NSSortDescriptor(key: "eloScore", ascending: false)]
        do {
            let records = try await database.perform(query, inZoneWith: nil)
            return records.map { record in
                Player(recordId: record.recordID, name: record["name"] as? String ?? "", email: record["email"] as? String ?? "", eloScore: record["eloScore"] as? Double ?? 0.0)
            }
        } catch let error {
            print(error)
        }
        return [Player]()
    }
    
    
    
    func updateElo(player: Player, eloChange: Double) async{
        do {
            let record1 = try await database.record(for: player.recordId!)
            record1["eloScore"] = eloChange
            try await save(record: record1)
        } catch let error {
            print(error)
        }
    }
    
    func save(record: CKRecord) async throws {
        do {
            try await self.database.save(record)
            print("Success to create record")
        } catch let error {
            print("cek")
            print(error.localizedDescription)
            throw error
        }
    }
}
