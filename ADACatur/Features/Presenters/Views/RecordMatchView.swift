//
//  RecordMatchView.swift
//  ADACatur
//
//  Created by Gregorius Yuristama Nugraha on 6/16/23.
//

import SwiftUI

struct RecordMatchView: View {
    
    @Environment(\.cloudKitContainer) var cloudKitContainer
    
    @State private var selectedOpponent = 0
    @State private var selectedResult = "Win"
    
    @State var allPlayers: [Player]?
    @State var currentPlayer: Player?
    
    private let results = ["Win", "Draw", "Lose"]
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
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
            } header: {
                Text("Match Result")
            }
            Button{
                print(currentPlayer?.recordId)
                print(allPlayers![selectedOpponent].recordId)
                print(allPlayers![selectedOpponent].name)
                print(selectedResult)
            }label: {
                Text("Done")
            }
        }
      
//
        .onAppear{
//            selectedOpponent = allPlayers?.first
            print(currentPlayer?.name)
        }
        .onChange(of: selectedOpponent) { newValue in
            print(allPlayers![newValue].name)
        }
    }
}



struct RecordMatchView_Previews: PreviewProvider {
    static var previews: some View {
        RecordMatchView()
    }
}
