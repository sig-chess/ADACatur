//
//  PlayerBoard.swift
//  ADACatur
//
//  Created by Ivan on 10/06/23.
//

import SwiftUI

struct PlayerRow: View {
    public var player: Player
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .foregroundColor(.gray)
                .font(.largeTitle)
            
            Text(player.name)
            
            Spacer()
            
            Text(String(format: "%.1f", player.eloScore))
        }
    }
}

struct PlayerRow_Previews: PreviewProvider {
    static var player = Player(
        name: "John Lewis",
        email: "john@gmail.com",
        eloScore: 85.5
    )
    
    static var previews: some View {
        PlayerRow(player: player)
    }
}
