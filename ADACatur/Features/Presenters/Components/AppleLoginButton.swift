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
//
//    @EnvironmentObject var state: GlobalState
//
//    @AppStorage("userID") private var userID: String = ""
//    @Binding public var isLogin: Bool
    
    var action: (_ result: Result<ASAuthorization, Error>) -> Void
    
    init(action: @escaping (_ result: Result<ASAuthorization, Error>) -> Void) {
        self.action = action
    }
    
    var body: some View {
        SignInWithAppleButton(
            onRequest: { request in
                // Perform any additional customization on the authorization request
                // For example, you can specify the requested scopes and other options
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                action(result)
            }
        )
        .signInWithAppleButtonStyle(
            colorScheme == .dark ? .white : .black
        )
    }
}

struct AppleLoginButton_Previews: PreviewProvider {
    static var previews: some View {
        AppleLoginButton(action: { result in })
            .environment(\.colorScheme, .dark)
    }
}
