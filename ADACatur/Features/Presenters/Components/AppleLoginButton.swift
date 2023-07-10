//
//  AppleLoginButton.swift
//  ADACatur
//
//  Created by beni garcia on 30/05/23.
//

import SwiftUI
import AuthenticationServices

struct AppleLoginButton: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.cloudKitContainer) var cloudKitContainer
    
    @AppStorage("userID") private var userID: String = ""
    @Binding public var isLogin: Bool
    
    var body: some View {
        SignInWithAppleButton(
            onRequest: { request in
                // Perform any additional customization on the authorization request
                // For example, you can specify the requested scopes and other options
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                // Handle the result of the sign-in process
                switch result {
                case .success(let auth):
                    print(result)
                    
                    // User signed in successfully with Apple ID
                    // Handle the user data from `authResult.credential`
                    switch auth.credential {
                    case let appleIdCredentials as ASAuthorizationAppleIDCredential:
                        if let container = cloudKitContainer {
                            let playerRepository = PlayerRepository(container: container)
                            
                            userID = appleIdCredentials.user
                            
                            //                            var player = Player(name: "", email: "")
                            Task {
                               await playerRepository.fetchUser(appleUserId: userID)
                            }
//                            print(playerRepository.player)
                            if playerRepository.player.name != "" {
                                isLogin = true
                                print("success login")
                            }
                            else {
                                Task {
                                    try await playerRepository.createPlayerViaAppleID(
                                        credentials: appleIdCredentials
                                    )
                                    print("saved new user")
                                    isLogin = true
                                }
                            }
                            
                            
                        } else {
                            print("Missing cloud kit container")
                        }
                    default:
                        print(auth.credential)
                    }
                    
                    break
                    
                case .failure(_):
                    // An error occurred during sign-in
                    // Handle the error
                    break
                }
            }
        )
        .signInWithAppleButtonStyle(
            colorScheme == .dark ? .white : .black
        )
    }
}

struct AppleLoginButton_Previews: PreviewProvider {
    static var previews: some View {
        AppleLoginButton(isLogin: .constant(false))
            .environment(\.colorScheme, .dark)
    }
}
