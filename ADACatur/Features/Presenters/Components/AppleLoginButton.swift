//
//  AppleLoginButton.swift
//  ADACatur
//
//  Created by beni garcia on 30/05/23.
//

import SwiftUI
import AuthenticationServices

struct AppleLoginButton: View {
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
                case .success(_):
                    // User signed in successfully with Apple ID
                    // Handle the user data from `authResult.credential`
                    break
                case .failure(_):
                    // An error occurred during sign-in
                    // Handle the error
                    break
                }
            }
        )
    }
}

struct AppleLoginButton_Previews: PreviewProvider {
    static var previews: some View {
        AppleLoginButton()
    }
}
