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
    @State private var allPlayers: [Player]? = []
    @State private var currentPlayer: Player?
    @State var allPlayerMatches: [PlayerMatch] = []
    @State var isShowingProgress: Bool = true
    @State var isShowingProgressHistory: Bool = true
  
    @AppStorage("userID") private var userID: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                Picker("", selection: $selectedTab) {
                    Text("Leaderboard").tag(Tab.leaderboard)
                    Text("Match Histories").tag(Tab.matches)
                }.pickerStyle(.segmented)
                
                if selectedTab == Tab.leaderboard {
                    LeaderboardView(players: allPlayers ?? [], isShowingProgress: $isShowingProgress)
                } else {
                    MatchHistoryView(playerMatches: allPlayerMatches, isShowingProgress: $isShowingProgressHistory)
                }
            }
//            ProgressView().opacity(isShowingProgress ? 1 : 0)
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
            RecordMatchView(allPlayers: $allPlayers, currentPlayer: self.currentPlayer)
        }
        .onAppear{
            if let container = cloudKitContainer {
                let playerRepository = PlayerRepository(container: container)
                Task {
                    isShowingProgress = true
                    isShowingProgressHistory = true
                    self.currentPlayer = await playerRepository.fetchUser(appleUserId: userID)
                    if playerRepository.player.name != "" {
                        playerName = String(playerRepository.player.name.split(separator: Character(" "))[0])
                        self.currentPlayer = playerRepository.player
                        print("success login")
                    }
                    Task{
                        self.allPlayers = await playerRepository.fetchAllUser()
                        isShowingProgress = false
                    }
                    
                    let playerMatchRepository = PlayerMatchRepository(container: container)
                    Task{
                        await playerMatchRepository.fetchPlayerMatch(player: self.currentPlayer!)
                        self.allPlayerMatches = playerMatchRepository.allPlayerMatches
                        isShowingProgressHistory = false
                    }
                }
            }
        }
        .refreshable {
            if let container = cloudKitContainer {
                let playerRepository = PlayerRepository(container: container)
                Task {
                    isShowingProgress = true
                    Task{
                        self.allPlayers = await playerRepository.fetchAllUser()
                    }
                    
                    let playerMatchRepository = PlayerMatchRepository(container: container)
                    Task{
                        await playerMatchRepository.fetchPlayerMatch(player: self.currentPlayer!)
                        self.allPlayerMatches = playerMatchRepository.allPlayerMatches
                    }
                    isShowingProgress = false
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
