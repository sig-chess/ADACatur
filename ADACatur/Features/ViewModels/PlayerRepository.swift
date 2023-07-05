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
        fetchAllUser()
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
    
    func fetchUser(appleUserId: String, completion: @escaping (CKRecord?) -> Void) {
        
        let predicate = NSPredicate(format: "appleUserId == %@", appleUserId)
        let query = CKQuery(recordType: RecordType.player.rawValue, predicate: predicate)
        
        
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.resultsLimit = 1
        
        var fetchedRecord: CKRecord?
        
        queryOperation.recordFetchedBlock = { record in
            // Process the fetched record
            fetchedRecord = record
        }
        
        queryOperation.queryCompletionBlock = { (cursor, error) in
            if let error = error {
                print("Error fetching record: \(error.localizedDescription)")
            }
            
            completion(fetchedRecord)
        }
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        database.add(queryOperation)
        
        queryOperation.completionBlock = {
            dispatchGroup.leave()
        }

        dispatchGroup.wait()
    }
    
    func fetchAllUser() {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: RecordType.player.rawValue, predicate: predicate)
        // TODO: uncomment once we want to sort this
        // query.sortDescriptors = [NSSortDescriptor(key: "eloScore", ascending: true)]
        
        database.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print(error)
            }
            
            if let records = records {
                let models = records.map { record in
                    Player(recordId: record.recordID, name: record["name"] as? String ?? "", email: record["email"] as? String ?? "", eloScore: record["eloScore"] as? Double ?? 0.0)
                }
                self.allPlayers = models
//                print(self.allPlayers)
            }
            
        }
    }
    
    func addOperation(operation: CKDatabaseOperation) {
        database.add(operation)
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
