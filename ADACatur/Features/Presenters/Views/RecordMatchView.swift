//
//  RecordMatchView.swift
//  ADACatur
//
//  Created by Gregorius Yuristama Nugraha on 6/16/23.
//

import SwiftUI

struct RecordMatchView: View {
    
    @Environment(\.cloudKitContainer) var cloudKitContainer
    
    @State private var selectedOpponent: Player?
    @State private var selectedResult = "Win"
    
    @State var allPlayers: [Player]?
    
    private let results = ["Win", "Draw", "Lose"]
    var body: some View {
        Form{
            Section{
                Picker("Opponent Name", selection: $selectedOpponent){
                    ForEach(allPlayers ?? [], id: \.self.recordId){ player in
                        Text(player.name)
                    }
                }
//                .pickerStyle(.menu)
            }
            
            Section {
                Picker("Result: ", selection: $selectedResult){
                    ForEach(results, id: \.self) {
                        Text($0)
                    }
                }
//                .pickerStyle(.menu)
                
            } header: {
                Text("Match Result")
            }

        }
        .onAppear{
            print(allPlayers)
            selectedOpponent = allPlayers?.first
        }
    }
}



struct RecordMatchView_Previews: PreviewProvider {
    static var previews: some View {
        RecordMatchView()
    }
}
