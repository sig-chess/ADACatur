//
//  Match.swift
//  ADACatur
//
//  Created by Ivan on 10/06/23.
//

import Foundation

struct Match {
    var id: UUID = UUID()
//    let recordId: CKRecord.ID?
//    let hostAppleId: String
    let startedAt: Date
    let finishedAt: Date
    let note: String
}
