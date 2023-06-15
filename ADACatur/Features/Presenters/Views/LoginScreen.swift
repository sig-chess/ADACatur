//
//  LoginScreen.swift
//  ADACatur
//
//  Created by beni garcia on 30/05/23.
//

import SwiftUI

struct LoginScreen: View {
    @Environment(\.cloudKitContainer) var cloudKitContainer
    @State private var isLogin: Bool = false
    
    @AppStorage("userID") private var userID: String = ""
    
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
            NavigationLink(destination: HomeView().navigationBarBackButtonHidden(true), isActive: $isLogin) {
                EmptyView()
            }
        }
        .onAppear{
            if let container = cloudKitContainer {
                
                let playerRepository = PlayerRepository(container: container)
                playerRepository.fetchItems(appleUserId: userID) {record in
                    if let fetchedRecord = record {
                        playerRepository.player.name = fetchedRecord["name"] as! String
                        playerRepository.player.email = fetchedRecord["email"] as! String
                    }
                }
                print(playerRepository.player)
                if playerRepository.player.name != "" {
                    isLogin = true
                    print("success login")
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
