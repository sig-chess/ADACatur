//
//  LoginScreen.swift
//  ADACatur
//
//  Created by beni garcia on 30/05/23.
//

import SwiftUI

struct LoginScreen: View {
    
    @EnvironmentObject var state: GlobalState
    
    @State private var isLogin: Bool = false
    
    @State private var isShowingProgress: Bool = false
    
    @AppStorage("userID") private var userID: String = ""
    
    var body: some View {
        ZStack{
            Image("wp-login")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(isShowingProgress ? 0 : 0.8)
            
            VStack{
                Spacer()
                AppleLoginButton(isLogin: $isLogin)
                    .frame(width: 345,height: 44)
            }
            .opacity(isShowingProgress ? 0 : 1)
            NavigationLink(destination:
                            HomeView()
                .environmentObject(state)
                                .navigationBarBackButtonHidden(true),
                           isActive: $isLogin) {
                EmptyView()
            }
            .opacity(isShowingProgress ? 0 : 1)
            ProgressView().opacity(isShowingProgress ? 1 : 0)
        }
        .onAppear{
            if userID != "" {
                Task {
                    isShowingProgress = true
                    let _ = await state.playerRepository.fetchUser(appleUserId: userID)
                    if state.playerRepository.player != nil {
                        isLogin = true
                        isShowingProgress = false
                    }
                }
            }
            
        }
        
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
