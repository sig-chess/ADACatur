//
//  RecordMatchView.swift
//  ADACatur
//
//  Created by Gregorius Yuristama Nugraha on 6/16/23.
//

import SwiftUI

struct RecordMatchView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var isShowingProgress: Bool
    @State var player: Player?
    @Binding var allPlayers: [Player]
    
    let addRecord: (_ result: ResultType, _ opponent: Player) async -> Void
    
    @State private var selectedOpponent: Int = 0
    @State private var selectedResult = ResultType.win
    @State private var isShowingAlert = false
    
    private let results = [ResultType.win, ResultType.draw, ResultType.lose]
    var body: some View {
        ZStack {
            Form {
                Section{
                    Picker("Opponent Name", selection: $selectedOpponent){
                        ForEach(0..<allPlayers.count, id: \.self){
                            Text("\(allPlayers[$0].name)").tag(allPlayers[$0].recordId)
                        }
//                        ForEach(allPlayers, id: \.self) { player in
//                            Text(player.name)
//                        }
                    }
                    .pickerStyle(.menu)
                }
//                Text("Selected!!!" + (selectedOpponent?.name ?? ""))
                Section {
                    Picker("Result: ", selection: $selectedResult){
                        ForEach(results, id: \.self) {
                            Text($0.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(.menu)
                } header: {
                    Text("Match Result")
                }
                Button{
                    
                    if allPlayers[selectedOpponent].recordId == player?.recordId {
                        isShowingAlert = true
                    } else {
//                        guard let selectedOpponent else { return }
                        isShowingProgress = true
                        Task {
                            await addRecord(selectedResult, allPlayers[selectedOpponent])
                            isShowingProgress = false
                            dismiss()
                        }
//                        Task{
//                            await addMatch()
//
//                            Task {
//                                await state.playerRepository.fetchAllUser()
//                                isShowingProgress = false
//                                dismiss()
//                            }
//                        }
                    }
                    
                }label: {
                    Text("Done")
                }
            }
            .alert("You cannot add your name as opponent", isPresented: $isShowingAlert) {
                Button("OK", role: .cancel) { }
            }
            .opacity(isShowingProgress ? 0 : 1)
            ProgressView().opacity(isShowingProgress ? 1 : 0)
        }
    }
//
//    func addMatch() async {
//        var opponentResult = ResultType.win
//        var scoreCurrentPlayer: Double = 0
//
//        switch selectedResult {
//        case .win:
//            opponentResult = .lose
//            scoreCurrentPlayer = 1
//        case .lose:
//            opponentResult = .win
//            scoreCurrentPlayer = 0
//        case .draw:
//            opponentResult = .draw
//            scoreCurrentPlayer = 0.5
//        }
//
//        let allPlayers = state.playerRepository.allPlayers
//
//        let currentPlayer = state.playerRepository.player
//
//        let playerA = allPlayers.first(where: {$0.recordId == currentPlayer?.recordId})
//
//        let playerB = allPlayers.first(where: {$0.recordId == allPlayers[selectedOpponent].recordId})
//
//        let (eloChangeA, eloChangeB) = CalculateElo.calculateEloChange(playerARating: playerA!.eloScore, playerBRating: playerB!.eloScore, playerAScore: scoreCurrentPlayer, kFactor: 32)
//
//        var newMatch = Match(startedAt: Date(), finishedAt: Date(), note: "")
//
//        let matchRecord = await state.matchRepository.addMatch(match: newMatch)
//
//        newMatch.recordId = matchRecord.recordID
//
//        let newPlayerMatch1 = PlayerMatch(player: (allPlayers.first(where: {$0.recordId == currentPlayer?.recordId}))!, match: newMatch, result: selectedResult, eloChange: (eloChangeA - playerA!.eloScore ))
//
//        let newPlayerMatch2 = PlayerMatch(player: (allPlayers.first(where: {$0.recordId == allPlayers[selectedOpponent].recordId}))!, match: newMatch, result: opponentResult, eloChange: (eloChangeB - playerB!.eloScore ))
//
//        await state.playerMatchRepository.addPlayerMatch(playerMatch1: newPlayerMatch1, playerMatch2: newPlayerMatch2)
//
//        await state.playerRepository.updateElo(player: playerA!, eloChange: eloChangeA)
//        await state.playerRepository.updateElo(player: playerB!, eloChange: eloChangeB)
//
//        await state.playerRepository.fetchAllUser()
//    }
}



struct RecordMatchView_Previews: PreviewProvider {
    static var previews: some View {
        RecordMatchView(isShowingProgress: false, player: Player(name: "", email: ""), allPlayers: .constant([]), addRecord: { _, _ in })
    }
}
