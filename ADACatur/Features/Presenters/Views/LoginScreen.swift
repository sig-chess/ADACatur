//
//  LoginScreen.swift
//  ADACatur
//
//  Created by beni garcia on 30/05/23.
//

import SwiftUI

struct LoginScreen: View {
    var body: some View {
        ZStack{
            Image("wp-login")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.8)
            VStack{
                Spacer()
                AppleLoginButton()
                    .frame(width: 345,height: 44)
            }
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
