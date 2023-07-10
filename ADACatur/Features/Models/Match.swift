//
//  Match.swift
//  ADACatur
//
//  Created by Ivan on 10/06/23.
//

import Foundation
import CloudKit

struct Match {
//    var id: UUID = UUID()
    // TODO: utilize this later
     var recordId: CKRecord.ID?
    // let hostAppleId: String
    let startedAt: Date
    let finishedAt: Date
    let note: String
    
    init(recordId: CKRecord.ID? = nil, startedAt: Date, finishedAt: Date, note: String) {
        self.recordId = recordId
        self.startedAt = startedAt
        self.finishedAt = finishedAt
        self.note = note
    }
}
