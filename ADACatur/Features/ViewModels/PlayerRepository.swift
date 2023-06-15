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
    
//    func iCloudUserIDAsync(complete: @escaping (_ instance: CKRecord.ID?, _ error: NSError?) -> ()) {
////        let container = CKContainer.default()
//        container.fetchUserRecordID() {
//            recordID, error in
//            if error != nil {
//                print(error!.localizedDescription)
//                complete(nil, error as NSError?)
//            } else {
//                print("fetched ID \(recordID?.recordName)")
//                complete(recordID, nil)
//            }
//        }
//    }
    
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
            
//            self.fetchAllUser()
            dispatchGroup.leave()
        }

        dispatchGroup.wait()
//
//        var returnedItems: Player?
//
//        queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
//            switch returnedResult {
//                case .success(let record):
//                    guard let name = record["name"] as? String, let email = record["email"] as? String, let eloScore = record["eloScore"] as? Double else { return }
//                    returnedItems = Player(name: name, email: email, eloScore: eloScore)
//                    print("Success fetch : \(returnedItems)")
//                    print(returnedResult)
//                case .failure(let error):
//                    print("Error recordMatchedBlock \(error)")
//                    print(returnedResult)
//                }
//
//        }
//
//        queryOperation.queryResultBlock = { [weak self] returnedResult  in
//            print("Returned queryResultBlock: \(returnedResult)")
//
//            DispatchQueue.main.sync {
//                self?.player = returnedItems!
//            }
//
//
//        }
//
//        print("fetching player : \(player)")
        
//        addOperation(operation: queryOperation)
        
    }
    
    func fetchAllUser() {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: RecordType.player.rawValue, predicate: predicate)
//        query.sortDescriptors = [NSSortDescriptor(key: "eloScore", ascending: true)]
        
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
//        let queryOperation = CKQueryOperation(query: query)
//
//        var returnedItems: [Player] = []
//
//        queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
//            switch returnedResult {
//            case .success(let record):
//                guard let name = record["name"] as? String, let email = record["email"] as? String, let eloScore = record["eloScore"] as? Double else { return }
//                returnedItems.append(Player(name: name, email: email, eloScore: eloScore))
////                print(returnedItems)
//            case .failure(let error):
//                print("Error recordMatchedBlock \(error)")
//            }
//
//        }
//
//        queryOperation.queryResultBlock = { [weak self] returnedResult  in
//            print("Returned queryResultBlock: \(returnedResult)")
//            DispatchQueue.main.async {
//                self?.allPlayers = returnedItems
//                print("All Player: \(self?.allPlayers)")
//            }
//
//        }
//
//        addOperation(operation: queryOperation)
        
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
