//
//  CalculateElo.swift
//  ChessADA
//
//  Created by beni garcia on 30/05/23.
//

import SwiftUI

struct CalculateElo: View {
    var playerARating = 800
    var playerBRating = 900
    var kFactor = 32
    var scorePlayerA = 1.0 // 1 = win, 0.5 draw, 0 lose
    @State var playerANewRating = 0
    @State var playerBNewRating  = 0
    @State var playerAWinProbability: Double = 0
    @State var playerBWinProbability: Double  = 0
    
    func calculateWinningProbability(playerARating: Double, playerBRating: Double) -> (playerAWinProbability: Double, playerBWinProbability: Double) {
        let expectedScoreA = 1 / (1 + pow(10, (playerBRating - playerARating) / 400))
        let expectedScoreB = 1 - expectedScoreA
        
        return (expectedScoreA, expectedScoreB)
    }
    
    func calculateEloChange(playerARating: Double, playerBRating: Double, playerAScore: Double, kFactor: Double) -> (playerANewRating: Int, playerBNewRating: Int) {
        let expectedScoreA = 1 / (1 + pow(10, (playerBRating - playerARating) / 400))
        let expectedScoreB = 1 - expectedScoreA
        
        let eloChangeA = kFactor * (playerAScore - expectedScoreA)
        let eloChangeB = kFactor * ((1 - playerAScore) - expectedScoreB)
        
        let playerANewRating = Int(playerARating + eloChangeA)
        let playerBNewRating = Int(playerBRating + eloChangeB)
        
        return (playerANewRating, playerBNewRating)
    }
    
    var body: some View {
        VStack{
            Text("Player A rating : \(playerARating)")
            Text("Player B rating : \(playerBRating)")
            Text("Player A's winning probability: \(playerAWinProbability)")
            Text("Player B's winning probability: \(playerBWinProbability)")
            Text("Player A rating now : \(playerANewRating)")
            Text("Player B rating now : \(playerBNewRating)")
            
        }
        .onAppear(){
            (playerAWinProbability, playerBWinProbability) = calculateWinningProbability(playerARating: Double(playerARating), playerBRating: Double(playerBRating))
            (playerANewRating, playerBNewRating) = calculateEloChange(playerARating: Double(playerARating), playerBRating: Double(playerBRating), playerAScore: Double(scorePlayerA), kFactor: Double(kFactor))
        }
    }
}

struct CalculateElo_Previews: PreviewProvider {
    static var previews: some View {
        CalculateElo()
    }
}
