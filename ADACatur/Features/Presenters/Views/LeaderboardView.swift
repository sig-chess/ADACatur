//
//  LeaderboardView.swift
//  ADACatur
//
//  Created by Ivan on 10/06/23.
//

import SwiftUI

struct LeaderboardView: View {
    public var players: [Player]
    
    var body: some View {
        List(players) { player in
            PlayerRow(player: player)
        }
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var players: [Player] = [
        .init(
            name: "John Lewis",
            email: "john@gmail.com",
            eloScore: 85.5
        ),
        .init(
            name: "Catherine",
            email: "catherine@gmail.com",
            eloScore: 65.5
        ),
        .init(
            name: "Raymond Lawrence",
            email: "raymond@gmail.com",
            eloScore: 35.5
        ),
        .init(
            name: "Maxwell Caulfield",
            email: "max@gmail.com",
            eloScore: 95.5
        ),
    ]
    
    static var previews: some View {
        LeaderboardView(players: players)
    }
}
