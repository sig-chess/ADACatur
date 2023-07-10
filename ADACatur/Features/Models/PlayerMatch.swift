//
//  PlayerMatch.swift
//  ADACatur
//
//  Created by Ivan on 10/06/23.
//

import Foundation

enum ResultType: String, CaseIterable {
    case win = "win"
    case lose = "lose"
    case draw = "draw"
}

struct PlayerMatch: Identifiable {
    var id: UUID = UUID()
    
    let player: Player
    let match: Match
    let result: ResultType
    let eloChange: Double
}
