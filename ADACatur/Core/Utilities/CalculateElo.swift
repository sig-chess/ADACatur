//
//  CalculateElo.swift
//  ADACatur
//
//  Created by Gregorius Yuristama Nugraha on 7/7/23.
//

import Foundation

class CalculateElo {
    init () {}
    static func calculateWinningProbability(playerARating: Double, playerBRating: Double) -> (playerAWinProbability: Double, playerBWinProbability: Double) {
        let expectedScoreA = 1 / (1 + pow(10, (playerBRating - playerARating) / 400))
        let expectedScoreB = 1 - expectedScoreA
        
        return (expectedScoreA, expectedScoreB)
    }
    
    static func calculateEloChange(playerARating: Double, playerBRating: Double, playerAScore: Double, kFactor: Double) -> (playerANewRating: Double, playerBNewRating: Double) {
        let expectedScoreA = 1 / (1 + pow(10, (playerBRating - playerARating) / 400))
        let expectedScoreB = 1 - expectedScoreA
        
        let eloChangeA = kFactor * (playerAScore - expectedScoreA)
        let eloChangeB = kFactor * ((1 - playerAScore) - expectedScoreB)
        
        let playerANewRating = playerARating + eloChangeA
        let playerBNewRating = playerBRating + eloChangeB
        
        return (playerANewRating, playerBNewRating)
    }
}
