//
//  LoginScreen.swift
//  ADACatur
//
//  Created by beni garcia on 30/05/23.
//

import SwiftUI
import AuthenticationServices

struct LoginScreen: View {
    
    //    @EnvironmentObject var state: GlobalState
    
    @ObservedObject var viewModel: LoginViewModel = LoginViewModel()
    
    var body: some View {
        ZStack{
            Image("wp-login")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(viewModel.isShowingProgress ? 0 : 0.8)
            
            VStack{
                Spacer()
                AppleLoginButton { result in
                    switch result {
                    case .success(let auth):
                        viewModel.createPlayer(auth: auth)
                    case .failure(_):
                        // An error occurred during sign-in
                        // Handle the error
                        break
                    }
                }
                .frame(width: 345,height: 44)
            }
            .opacity(viewModel.isShowingProgress ? 0 : 1)
            NavigationLink(destination:
                            HomeView()
                .navigationBarBackButtonHidden(true),
                           isActive: $viewModel.isLogin) {
                EmptyView()
            }
            .opacity(viewModel.isShowingProgress ? 0 : 1)
            ProgressView().opacity(viewModel.isShowingProgress ? 1 : 0)
        }
        
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
