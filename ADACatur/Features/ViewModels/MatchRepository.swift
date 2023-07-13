//
//  MatchRepository.swift
//  ADACatur
//
//  Created by Gregorius Yuristama Nugraha on 7/9/23.
//

import Foundation
import CloudKit

class MatchRepository {
    private var database: CKDatabase
    private var container: CKContainer
    
    init(container: CKContainer) {
        self.container = container
        self.database = self.container.publicCloudDatabase
    }
    
    func addMatch(match: Match) async -> CKRecord{
        let record = CKRecord(recordType: RecordType.match.rawValue)
        
        record["startedAt"] = match.startedAt
        record["finishedAt"] = match.finishedAt
        record["note"] = match.note
        
        try? await save(record: record)
        return record
    }
    
    func save(record: CKRecord) async throws {
        do {
            try await self.database.save(record)
            print("Success to create record")
        } catch let error {
            print(error.localizedDescription)
            throw error
        }
    }
    
}
