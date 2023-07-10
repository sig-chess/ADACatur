//
//  RecordMatchView.swift
//  ADACatur
//
//  Created by Gregorius Yuristama Nugraha on 6/16/23.
//

import SwiftUI

struct RecordMatchView: View {
    
    @Environment(\.cloudKitContainer) var cloudKitContainer
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedOpponent = 0
    @State private var selectedResult = ResultType.win
    
    @Binding var allPlayers: [Player]?
    @State var currentPlayer: Player?
    
    private let results = [ResultType.win, ResultType.draw, ResultType.lose]
    var body: some View {
        Form{
            Section{
                Picker("Opponent Name", selection: $selectedOpponent){

                    ForEach(0..<allPlayers!.count){
                        Text("\(allPlayers![$0].name)")
                    }
                }
                .pickerStyle(.menu)
            }
            
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
                Task{
                    await addMatch()
                    if let container = cloudKitContainer {
                        let playerRepository = PlayerRepository(container: container)
                        Task {
                            self.allPlayers = await playerRepository.fetchAllUser()
                            dismiss()
                        }
                    }
                }
            }label: {
                Text("Done")
            }
        }
        .onChange(of: selectedOpponent) { newValue in
            print(allPlayers![newValue].name)
        }
    }
    func addMatch() async {
        var opponentResult = ResultType.win
        var scoreCurrentPlayer: Double = 0
        
        switch selectedResult {
        case .win:
            opponentResult = .lose
            scoreCurrentPlayer = 1
        case .lose:
            opponentResult = .win
            scoreCurrentPlayer = 0
        case .draw:
            opponentResult = .draw
            scoreCurrentPlayer = 0.5
        }
        
        let playerA = allPlayers?.first(where: {$0.recordId == currentPlayer?.recordId})
        
        let playerB = allPlayers?.first(where: {$0.recordId == allPlayers![selectedOpponent].recordId})
        
        let (eloChangeA, eloChangeB) = CalculateElo.calculateEloChange(playerARating: playerA!.eloScore, playerBRating: playerB!.eloScore, playerAScore: scoreCurrentPlayer, kFactor: 32)
        
        if let container = cloudKitContainer {
            let matchRepository = MatchRepository(container: container)
            let playerMatchRepository = PlayerMatchRepository(container: container)
            let playerRepository = PlayerRepository(container: container)
            
            var newMatch = Match(startedAt: Date(), finishedAt: Date(), note: "")
            
            let matchRecord = matchRepository.addMatch(match: newMatch)
            
            newMatch.recordId = matchRecord.recordID
            
            let newPlayerMatch1 = PlayerMatch(player: (allPlayers?.first(where: {$0.recordId == currentPlayer?.recordId}))!, match: newMatch, result: selectedResult, eloChange: (eloChangeA - playerA!.eloScore ))
            
            let newPlayerMatch2 = PlayerMatch(player: (allPlayers?.first(where: {$0.recordId == allPlayers![selectedOpponent].recordId}))!, match: newMatch, result: opponentResult, eloChange: (eloChangeB - playerB!.eloScore ))
            
            playerMatchRepository.addPlayerMatch(playerMatch1: newPlayerMatch1, playerMatch2: newPlayerMatch2)
            
            playerRepository.updateElo(player: playerA!, eloChange: eloChangeA)
            playerRepository.updateElo(player: playerB!, eloChange: eloChangeB)
            
            print(newMatch)
            print(newPlayerMatch1)
            print(newPlayerMatch2)
            
        }
    }
}



struct RecordMatchView_Previews: PreviewProvider {
    static var previews: some View {
        RecordMatchView(allPlayers: .constant([]))
    }
}
