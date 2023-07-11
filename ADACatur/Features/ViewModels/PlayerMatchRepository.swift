//
//  PlayerMatchRepository.swift
//  ADACatur
//
//  Created by Gregorius Yuristama Nugraha on 7/9/23.
//

import Foundation
import CloudKit

class PlayerMatchRepository: ObservableObject {
    private var database: CKDatabase
    private var container: CKContainer
    
    @Published var allPlayerMatches: [PlayerMatch] = []
    
    init(container: CKContainer) {
        self.container = container
        self.database = self.container.publicCloudDatabase
    }
    
    func addPlayerMatch(playerMatch1: PlayerMatch, playerMatch2: PlayerMatch) async {
        let record1 = CKRecord(recordType: RecordType.playerMatch.rawValue)
        
        record1["playerId"] = playerMatch1.player.recordId?.recordName
        record1["matchId"] = playerMatch1.match.recordId?.recordName
        record1["result"] = playerMatch1.result.rawValue
        record1["eloChange"] = playerMatch1.eloChange
        //
        await save(record: record1)
        
        let record2 = CKRecord(recordType: RecordType.playerMatch.rawValue)
        
        record2["playerId"] = playerMatch2.player.recordId?.recordName
        record2["matchId"] = playerMatch2.match.recordId?.recordName
        record2["result"] = playerMatch2.result.rawValue
        record2["eloChange"] = playerMatch2.eloChange
        await save(record: record2)
    }
    
    func save(record: CKRecord) async {
        do {
            let newRecord = try await self.database.save(record)
            print("Success to create record")
        } catch let error {
            print(error)
        }
    }
    
    func fetchPlayerMatch(player: Player) async  {
        let predicate = NSPredicate(format: "playerId == %@", player.recordId!.recordName)
        let query = CKQuery(recordType: RecordType.playerMatch.rawValue, predicate: predicate)
        
        query.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
        //        let queryOperation = CKQueryOperation(query: query)
        
        do {
            let records = try await database.perform(query, inZoneWith: nil)
            for record in records {
                
                var fetchedMatch: Match = Match(startedAt: Date(), finishedAt: Date(), note: "")
                
                let matchRecordID = CKRecord.ID(recordName: record["matchId"]!)
                
                
                //                    let matchDatabase = CKContainer()
                
                let matchDatabase = self.container.publicCloudDatabase
                let matchPredicate = NSPredicate(format: "recordID == %@", matchRecordID)
                let matchQuery = CKQuery(recordType: RecordType.match.rawValue, predicate: matchPredicate)
                
                
                
                do {
                    let matchRecords = try await matchDatabase.perform(matchQuery, inZoneWith: nil)
                    for mRecord in matchRecords {
                        //                                print(mRecord["finishedAt"]!)
                        fetchedMatch = Match(recordId: mRecord.recordID,startedAt: mRecord["startedAt"] as! Date, finishedAt: mRecord["finishedAt"] as! Date, note: mRecord["note"] as! String)
                    }
                } catch let matchError {
                    print(matchError)
                }
                
                let opponentDatabase = self.container.publicCloudDatabase
                
                let opponentPredicate = NSPredicate(format: "matchId == %@ && playerId != %@", matchRecordID.recordName, player.recordId!.recordName)
                let opponentQuery = CKQuery(recordType: RecordType.playerMatch.rawValue, predicate: opponentPredicate)
                //                    let opponentQueryOperation = CKQueryOperation(query: opponentQuery)
                //
                var fetchedOpponent: Player = Player(name: "", email: "")
                
                do {
                    let opponentRecord = try await opponentDatabase.perform(opponentQuery, inZoneWith: nil)
                    for oRecord in opponentRecord {
                        //                                print("Player ID: \(oRecord["playerId"]!)")
                        let opponentRecordID = CKRecord.ID(recordName: oRecord["playerId"] as! String)
                        let playerOpponentDatabase = self.container.publicCloudDatabase
                        let playerOpponentPredicate = NSPredicate(format: "recordID == %@", opponentRecordID)
                        let playerOpponentQuery = CKQuery(recordType: RecordType.player.rawValue, predicate: playerOpponentPredicate)
                        
                        do {
                            let playerOpponentRecord = try await playerOpponentDatabase.perform(playerOpponentQuery, inZoneWith: nil)
                            for pRecord in playerOpponentRecord {
//                                print("\(pRecord["name"]!)")
                                fetchedOpponent = Player(recordId: pRecord.recordID,name: pRecord["name"] as! String, email: pRecord["email"] as! String,eloScore: pRecord["eloScore"] as! Double )
                            }
                        } catch let playerOpponentError {
                            print(playerOpponentError)
                        }
                        
                    }
                } catch let opponentError {
                    print(opponentError)
                }
                
                var returnResult: ResultType = .win
                
                if record["result"] == "win" {
                    returnResult = .win
                } else if record["result"] == "draw" {
                    returnResult = .draw
                } else if record["result"] == "lose"{
                    returnResult = .lose
                }
                
                self.allPlayerMatches.append(PlayerMatch(player: fetchedOpponent, match: fetchedMatch, result: returnResult, eloChange: record["eloChange"] as! Double))
            }
//            print(allPlayerMatches)
        } catch let error {
            print(error)
        }
        
    }
}
