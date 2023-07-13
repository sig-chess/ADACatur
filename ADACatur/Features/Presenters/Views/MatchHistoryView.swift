//
//  MatchHistoryView.swift
//  ADACatur
//
//  Created by Ivan on 10/06/23.
//

import SwiftUI

struct MatchHistoryView: View {
    
    @Binding var isShowingProgress: Bool
    @Binding var allPlayerMatches: [PlayerMatch]
    
    let refreshAllPlayerMatches: () -> Void
    
    var body: some View {
        ZStack {
            if allPlayerMatches.isEmpty {
                VStack {
                    Spacer()
                    
                    Text("No Match")
                    
                    Spacer()
                }
                .opacity(isShowingProgress ? 0 : 1)
            } else {
                List(allPlayerMatches) { playerMatch in
                    MatchRow(playerMatch: playerMatch)
                }
                .opacity(isShowingProgress ? 0 : 1)
            }
            ProgressView().opacity(isShowingProgress ? 1 : 0)
        }
        .refreshable {
            
            refreshAllPlayerMatches()
        }
        .onAppear{
            refreshAllPlayerMatches()
        }
    }
}

struct MatchHistoryView_Previews: PreviewProvider {
    static var opponent = Player(
        name: "John Lewis",
        email: "john@gmail.com"
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
        MatchHistoryView(isShowingProgress: .constant(false), allPlayerMatches: .constant([]), refreshAllPlayerMatches: { })
    }
}
