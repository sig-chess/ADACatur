//
//  Match.swift
//  ADACatur
//
//  Created by Ivan on 10/06/23.
//

import Foundation

struct Match: Identifiable {
    var id: UUID = UUID()
    let startedAt: Date
    let finishedAt: Date
    let note: String
}
