//
//  Player.swift
//  ADACatur
//
//  Created by Ivan on 10/06/23.
//

import Foundation

struct Player: Identifiable {
    var id: UUID = UUID()
    let name: String
    let email: String
    let eloScore: Double
}
