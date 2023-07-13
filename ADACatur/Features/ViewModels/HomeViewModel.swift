//
//  HomeViewModel.swift
//  ADACatur
//
//  Created by Gregorius Yuristama Nugraha on 7/12/23.
//

import Foundation
import CloudKit

class HomeViewModel: ObservableObject {
    
    let container: CKContainer
    let playerRepository: PlayerRepository
    let playerMatchRepository: PlayerMatchRepository
    let matchRepository: MatchRepository
    
    @Published var player: Player?
    @Published var allPlayers: [Player] = []
    @Published var allPlayerMatches: [PlayerMatch] = []
    @Published var isShowingProgress: Bool = false
    @Published var isShowingProgressHistory: Bool = false
    
    init() {
        self.container = CKContainer.init(identifier: containerName)
        playerRepository = PlayerRepository(container: self.container)
        playerMatchRepository = PlayerMatchRepository(container: self.container)
        matchRepository = MatchRepository(container: self.container)
        
        Task {
            DispatchQueue.main.async{
                self.isShowingProgress = true
                self.isShowingProgressHistory = true
            }
            await getPlayer()
            await getAllPlayers()
            DispatchQueue.main.async {
                self.isShowingProgress = false
            }
            await getAllPlayerMatches()
            DispatchQueue.main.async {
                self.isShowingProgressHistory = false
            }
        }
    }
    
    func getPlayer() async {
        Task {
            guard let id = UserDefaults.standard.string(forKey: "userID") else { return }
            let result = await playerRepository.fetchUser(appleUserId: id)
            
            DispatchQueue.main.async {
                self.player = result
            }
        }
    }
    
    func getAllPlayers() async {
        DispatchQueue.main.async {
            self.isShowingProgress = true
            self.allPlayers = [Player]()
        }
        let result = await playerRepository.fetchAllUser()
        
        DispatchQueue.main.async {
            self.allPlayers = result
            print(self.allPlayers)
            self.isShowingProgress = false
        }
        
    }
    
    func getAllPlayerMatches() async {
        DispatchQueue.main.async {
            self.isShowingProgressHistory = true
        }
        Task {
            await getPlayer()
            guard let player else {
                DispatchQueue.main.async {
                    self.isShowingProgress = false
                }
                return
            }
            let result = await playerMatchRepository.fetchPlayerMatch(player: player)
            DispatchQueue.main.async {
                self.allPlayerMatches = result
                self.isShowingProgressHistory = false
            }
        }
    }
    
    func addRecord(result: ResultType, opponent: Player) async {
        guard let player else { return }
        DispatchQueue.main.async {
            self.isShowingProgress = true
        }
        
        var opponentResult: ResultType
        var scoreCurrentPlayer: Double
        
        switch result {
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
        
        let (eloChangeA, eloChangeB) = CalculateElo.calculateEloChange(playerARating: player.eloScore, playerBRating: opponent.eloScore, playerAScore: scoreCurrentPlayer, kFactor: 32)
        
        var newMatch = Match(startedAt: Date(), finishedAt: Date(), note: "")
        
        let matchRecord = await matchRepository.addMatch(match: newMatch)
        
        newMatch.recordId = matchRecord.recordID
        
        let playerMatch = PlayerMatch(player: player, match: newMatch, result: result, eloChange: (eloChangeA - player.eloScore ))
        
        let opponentMatch = PlayerMatch(player: opponent, match: newMatch, result: opponentResult, eloChange: (eloChangeB - opponent.eloScore ))
        
        await playerMatchRepository.addPlayerMatch(playerMatch1: playerMatch, playerMatch2: opponentMatch)
        
        await playerRepository.updateElo(player: player, eloChange: eloChangeA)
        await playerRepository.updateElo(player: opponent, eloChange: eloChangeB)
        
        
        await getAllPlayers()
        DispatchQueue.main.async {
            self.isShowingProgress = false
        }
        
    }
}
