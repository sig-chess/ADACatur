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
    
    @Environment(\.cloudKitContainer) var cloudKitContainer
  
    @State private var selectedTab: Tab = .leaderboard
    @State private var showSheet: Bool = false
    @State private var playerName: String = ""
    @State private var allPlayers: [Player] = []
    @State private var currentPlayer: Player?
  
    @AppStorage("userID") private var userID: String = ""
    
    var body: some View {
        VStack {
            Picker("", selection: $selectedTab) {
                Text("Leaderboard").tag(Tab.leaderboard)
                Text("Match Histories").tag(Tab.matches)
            }.pickerStyle(.segmented)
            
            if selectedTab == Tab.leaderboard {
                LeaderboardView(players: allPlayers)
            } else {
                MatchHistoryView(playerMatches: playerMatches)
            }
        }
        .navigationTitle(Text("Hi \(playerName)!"))
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
            RecordMatchView(allPlayers: self.allPlayers, currentPlayer: self.currentPlayer)
        }
        .onAppear{
            if let container = cloudKitContainer {
                
                let playerRepository = PlayerRepository(container: container)
                playerRepository.fetchUser(appleUserId: userID) {record in
                    if let fetchedRecord = record {
                        playerRepository.player.name = fetchedRecord["name"] as! String
                        playerRepository.player.email = fetchedRecord["email"] as! String
                        playerRepository.player.recordId = fetchedRecord.recordID
                    }
                }
                if playerRepository.player.name != "" {
                    // TODO: flag whether user has already login
                    // isLogin = true
                    playerName = String(playerRepository.player.name.split(separator: Character(" "))[0])
                    self.currentPlayer = playerRepository.player
                    print("success login")
                }
                Task{
                    try await playerRepository.fetchAllUser()
                }
                
                self.allPlayers = playerRepository.allPlayers
                print(playerRepository.allPlayers)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
