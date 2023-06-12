//
//  LoginScreen.swift
//  ADACatur
//
//  Created by beni garcia on 30/05/23.
//

import SwiftUI

struct LoginScreen: View {
    @State private var isLogin: Bool = false
    
    var body: some View {
        ZStack{
            Image("wp-login")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.8)
            VStack{
                Spacer()
                AppleLoginButton(isLogin: $isLogin)
                    .frame(width: 345,height: 44)
            }
            
            NavigationLink(destination: HomeView(), isActive: $isLogin) {
                EmptyView()
            }
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
