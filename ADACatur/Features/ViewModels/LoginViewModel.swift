//
//  LoginViewModel.swift
//  ADACatur
//
//  Created by Gregorius Yuristama Nugraha on 7/12/23.
//

import Foundation
import CloudKit
import AuthenticationServices

class LoginViewModel: ObservableObject {
    
    let container: CKContainer
    let playerRepository: PlayerRepository
    
    var userId: String?
    
    @Published var isLogin: Bool = false
    @Published var player: Player?
    @Published var isShowingProgress: Bool = false
    
    init() {
        container = CKContainer.init(identifier: containerName)
        playerRepository = PlayerRepository(container: container)
        
        if let id = UserDefaults.standard.string(forKey: "userID") {
            userId = id
            Task {
                isShowingProgress = true
                let currentPlayer = await playerRepository.fetchUser(appleUserId: id)
                DispatchQueue.main.async {
                    self.player = currentPlayer
                    self.isLogin = true
                    self.isShowingProgress = false
                }
            }
        } else {
            self.player = nil
        }
    }
    
    func createPlayer(auth: ASAuthorization) {
        switch auth.credential {
        case let appleIdCredentials as ASAuthorizationAppleIDCredential:
            let userID = appleIdCredentials.user
            
            playerRepository.createPlayerViaAppleID(credentials: appleIdCredentials) { status, error in
                // Do something
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                DispatchQueue.main.async {
                    UserDefaults.standard.set(userID, forKey: "userID")
                    self.isLogin = true
                }
            }
            
            
        default:
            print(auth.credential)
        }
        
    }
}
