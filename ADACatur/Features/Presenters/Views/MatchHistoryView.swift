//
//  MatchHistoryView.swift
//  ADACatur
//
//  Created by Ivan on 10/06/23.
//

import SwiftUI

struct MatchHistoryView: View {
    public var playerMatches: [PlayerMatch]
    
    var body: some View {
        if playerMatches.isEmpty {
            VStack {
                Spacer()
                
                Text("No Match")
                
                Spacer()
            }
        } else {
            List(playerMatches) { playerMatch in
                MatchRow(playerMatch: playerMatch)
            }
        }
    }
}

struct MatchHistoryView_Previews: PreviewProvider {
    static var opponent = Player(
        name: "John Lewis",
        email: "john@gmail.com",
        eloScore: 85.5
    )
    
    static var playerMatches: [PlayerMatch] = [
        .init(
            player: opponent,
            match: .init(startedAt: .now, finishedAt: .now, note: ""),
            result: .lose,
            eloChange: 1.0
        ),
        .init(
            player: opponent,
            match: .init(startedAt: .now, finishedAt: .now, note: ""),
            result: .draw,
            eloChange: 0.0
        ),
        .init(
            player: opponent,
            match: .init(startedAt: .now, finishedAt: .now, note: ""),
            result: .win,
            eloChange: 4.0
        )
    ]
    
    static var previews: some View {
        MatchHistoryView(playerMatches: playerMatches)
    }
}
