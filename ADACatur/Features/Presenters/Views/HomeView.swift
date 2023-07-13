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
    
    @ObservedObject var viewModel: HomeViewModel = HomeViewModel()
    
    @State private var selectedTab: Tab = .leaderboard
    @State private var showSheet: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Picker("", selection: $selectedTab) {
                    Text("Leaderboard").tag(Tab.leaderboard)
                    Text("Match Histories").tag(Tab.matches)
                }.pickerStyle(.segmented)
                
                if selectedTab == Tab.leaderboard {
                    LeaderboardView(isShowingProgress: $viewModel.isShowingProgress, allPlayers: $viewModel.allPlayers) {
                        await self.viewModel.getAllPlayers()
                    }
                        
                } else {
                    MatchHistoryView(isShowingProgress: $viewModel.isShowingProgressHistory, allPlayerMatches: $viewModel.allPlayerMatches) {
                        Task {
                            await self.viewModel.getAllPlayerMatches()
                        }
                    }
                }
            }
        }
        
        .navigationTitle(Text("Hi \(viewModel.player?.name.components(separatedBy: " ").first ?? "")!"))
        .navigationBarItems(trailing: HStack {
            Button(action: {
                showSheet.toggle()
            }) {
                Image(systemName: "plus")
                    .frame(width: 20, height: 20)
            }
        })
        .sheet(isPresented: $showSheet) {
            RecordMatchView(isShowingProgress: viewModel.isShowingProgress, player: viewModel.player, allPlayers: $viewModel.allPlayers) { result, opponent in
                await viewModel.addRecord(result: result, opponent: opponent)
            }
        }
//        .onAppear{
//            Task {
//                isShowingProgress = true
//                isShowingProgressHistory = true
//                await state.playerRepository.fetchUser(appleUserId: userID)
//                playerName = String(state.playerRepository.player?.name.split(separator: Character(" "))[0] ?? "")
//                Task{
//                    await state.playerRepository.fetchAllUser()
//                    isShowingProgress = false
//                }
//                guard let player = self.state.playerRepository.player else { return }
//                await state.playerMatchRepository.fetchPlayerMatch(player: player)
//                isShowingProgressHistory = false
//            }
//        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
