//
//  LeaderboardView.swift
//  ADACatur
//
//  Created by Ivan on 10/06/23.
//

import SwiftUI

struct LeaderboardView: View {
    @Binding var players: [Player]
    @Binding var isShowingProgress: Bool
    
    var body: some View {
        ZStack {
            if players.isEmpty {
                VStack {
                    Spacer()
                    
                    Text("No player")
                    
                    Spacer()
                }
                .opacity(isShowingProgress ? 0 : 1)
            } else {
                List(players, id: \.self.recordId) { player in
                    PlayerRow(player: player)
                }
                .opacity(isShowingProgress ? 0 : 1)
            }
            ProgressView().opacity(isShowingProgress ? 1 : 0)
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
        LeaderboardView(players: .constant(players), isShowingProgress: .constant(false))
    }
}
