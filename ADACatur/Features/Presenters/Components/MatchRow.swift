//
//  MatchRow.swift
//  ADACatur
//
//  Created by Ivan on 10/06/23.
//

import SwiftUI

struct MatchRow: View {
    public var playerMatch: PlayerMatch
    
    
    func convertDateFormat(_ date: Date) -> String {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "EEEE, d MMMM yyyy"
        let outputString = outputFormatter.string(from: date)
        
        return outputString
    }
    
    func colorResult(_ result: ResultType) -> Color {
        if result == ResultType.win {
            return Color.green
        } else if result == ResultType.lose {
            return Color.red
        } else {
            return Color.black
        }
    }
    
    func formatElo(eloChange: Double, result: ResultType) -> String {
        if result == ResultType.win {
            return "+" + String(format: "%.1f", eloChange)
        } else if result == ResultType.lose {
            return "-" + String(format: "%.1f", eloChange)
        } else {
            return String(format: "%.1f", eloChange)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Text(convertDateFormat(playerMatch.match.startedAt))
            }
            
            HStack {
                Image(systemName: "person.circle.fill")
                    .foregroundColor(.gray)
                    .font(.largeTitle)
                
                Text(playerMatch.player.name)
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Text("\(playerMatch.result.rawValue)")
                        .foregroundColor(colorResult(playerMatch.result))
                    
                    Text("(\(formatElo(eloChange: playerMatch.eloChange, result: playerMatch.result)))")
                        .foregroundColor(colorResult(playerMatch.result))
                }
            }
        }
    }
}

struct MatchRow_Previews: PreviewProvider {
    static var opponent = Player(
        name: "Catherine",
        email: "catherine@gmail.com",
        eloScore: 85.5
    )
    
    static var match = Match(
        startedAt: .now,
        finishedAt: .now,
        note: ""
    )
    
    static var playerMatch = PlayerMatch(
        player: opponent,
        match: match,
        result: .win,
        eloChange: 4.0
    )
    
    static var previews: some View {
        MatchRow(playerMatch: playerMatch)
    }
}
