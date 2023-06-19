//
//  RecordMatchView.swift
//  ADACatur
//
//  Created by Gregorius Yuristama Nugraha on 6/16/23.
//

import SwiftUI

struct RecordMatchView: View {
    
    @State private var selectedOption = "Option 1"
    private let options = ["Option 1", "Option 2", "Option 3"]
    var body: some View {
        Form{
            Section{
                Picker("Opponent Name", selection: $selectedOption){
                    ForEach(options, id: \.self){
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
            }
//            .navigationTitle("Opponent Name")
            
            Section {
                Picker("Result: ", selection: $selectedOption){
                    Text("Win")
                    Text("Draw")
                    Text("Lose")
                }
                
            } header: {
                Text("Match Result")
            }

        }
    }
}



struct RecordMatchView_Previews: PreviewProvider {
    static var previews: some View {
        RecordMatchView()
    }
}
