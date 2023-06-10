//
//  HomeView.swift
//  ADACatur
//
//  Created by Ivan on 10/06/23.
//

import SwiftUI

enum Tab {
    case leaderboard
    case matches
}

private var players: [Player] = [
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
]

private var playerMatches: [PlayerMatch] = [
    .init(
        player: players[0],
        match: .init(startedAt: .now, finishedAt: .now, note: ""),
        result: .lose,
        eloChange: 1.0
    ),
    .init(
        player: players[2],
        match: .init(startedAt: .now, finishedAt: .now, note: ""),
        result: .draw,
        eloChange: 0.0
    ),
    .init(
        player: players[1],
        match: .init(startedAt: .now, finishedAt: .now, note: ""),
        result: .win,
        eloChange: 4.0
    )
]

struct HomeView: View {
    @State private var selectedTab: Tab = .leaderboard
    @State private var showSheet: Bool = false
    
    
    var body: some View {
        VStack {
            Picker("", selection: $selectedTab) {
                Text("Leaderboard").tag(Tab.leaderboard)
                Text("Match Histories").tag(Tab.matches)
            }.pickerStyle(.segmented)
            
            if selectedTab == Tab.leaderboard {
                LeaderboardView(players: players)
            } else {
                MatchHistoryView(playerMatches: playerMatches)
            }
        }
        .navigationTitle(Text("Hi \("Ivan")"))
        .navigationBarItems(trailing: HStack {
            //button 1
            Button(action: {
                showSheet.toggle()
            }) {
                Image(systemName: "plus")
                .frame(width: 20, height: 20)
            }
        })
        .sheet(isPresented: $showSheet) {
            Text("Add Match")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}