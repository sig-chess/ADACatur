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

struct HomeView: View {
    
    @EnvironmentObject var state: GlobalState
    
    @State private var selectedTab: Tab = .leaderboard
    @State private var showSheet: Bool = false
    @State private var playerName: String = ""
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
                    LeaderboardView(isShowingProgress: $isShowingProgress)
                        .environmentObject(state)
                        
                } else {
                    MatchHistoryView(isShowingProgress: $isShowingProgressHistory)
                        .environmentObject(state)
                }
            }
        }
        
        .navigationTitle(Text("Hi \(playerName)!"))
        .navigationBarItems(trailing: HStack {
            Button(action: {
                showSheet.toggle()
            }) {
                Image(systemName: "plus")
                    .frame(width: 20, height: 20)
            }
        })
        .sheet(isPresented: $showSheet) {
            RecordMatchView()
                .environmentObject(state)
        }
        .onAppear{
            Task {
                isShowingProgress = true
                isShowingProgressHistory = true
                await state.playerRepository.fetchUser(appleUserId: userID)
                playerName = String(state.playerRepository.player?.name.split(separator: Character(" "))[0] ?? "")
                Task{
                    await state.playerRepository.fetchAllUser()
                    isShowingProgress = false
                }
                guard let player = self.state.playerRepository.player else { return }
                await state.playerMatchRepository.fetchPlayerMatch(player: player)
                isShowingProgressHistory = false
            }
        }
        
        
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
