//
//  PlayerViewModel.swift
//  ADACatur
//
//  Created by Ivan on 11/06/23.
//

import Foundation
import AuthenticationServices
import CloudKit

class PlayerViewModel {
    
    func createPlayerViaAppleSignIn(
        credentials: ASAuthorizationAppleIDCredential,
        container: CKContainer
    ) {
        guard
            let name = credentials.fullName?.givenName,
            let email = credentials.email
        else { return }
            
        let playerRepository: PlayerRepository = PlayerRepository(container: container)
        
        playerRepository.createPlayer(
            name: name,
            email: email,
            eloScore: 0.0,
            appleUserId: credentials.user
        )
    }
}
