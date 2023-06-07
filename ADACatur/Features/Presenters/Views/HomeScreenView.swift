//
//  HomeScreenView.swift
//  ADACatur
//
//  Created by beni garcia on 07/06/23.
//

import SwiftUI

struct HomeScreenView: View {
    @State private var selectedSegment = 0
    private let segments = ["Leaderboard", "Match History"]
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text("Hi, Kevin!")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 42,height: 42)
            }
            
            Picker(selection: $selectedSegment, label: Text("Segments")) {
                ForEach(0..<segments.count) { index in
                    Text(segments[index])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            switch selectedSegment {
            case 0:
                VStack(alignment: .leading){
                    Text("Leaderboard")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.vertical)
                    List(){
                        //for each
                        HStack{
                            Image(systemName: "1.square.fill")
                                .resizable()
                                .frame(width: 44,height: 44)
                                .padding(.trailing,4)
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 40,height: 40)
                            VStack{
                                Text("Kepin gans")
                                    .font(.title3)
                            }
                            Spacer()
                            HStack{
                                Image(systemName: "trophy")
                                Text("854")
                            }
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding(7)
                            .padding(.horizontal,10)
                            .background(Color.blue)
                            .cornerRadius(6)
                        }
                        HStack{
                            Image(systemName: "2.square.fill")
                                .resizable()
                                .frame(width: 44,height: 44)
                                .padding(.trailing,4)
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 40,height: 40)
                            VStack{
                                Text("Kepin gans")
                                    .font(.title3)
                            }
                            Spacer()
                            HStack{
                                Image(systemName: "trophy")
                                Text("854")
                            }
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding(7)
                            .padding(.horizontal,10)
                            .background(Color.blue)
                            .cornerRadius(6)
                        }
                    }
                    .listStyle(.plain)
                }
            case 1:
                VStack(alignment: .leading){
                    Text("Match History")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.vertical)
                    List(){
                        //for each
                        HStack{
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 40,height: 40)
                            VStack(alignment: .leading, spacing: 4){
                                Text("Kepin gans")
                                    .font(.title3)
                                HStack{
                                    Image(systemName: "trophy")
                                    Text("854")
                                }
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .padding(5)
                                .background(Color.blue)
                                .cornerRadius(6)
                            }
                            Spacer()
                            Text("Win +24")
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding(7)
                            .padding(.horizontal,10)
                            .background(Color.green)
                            .cornerRadius(6)
                        }
                        HStack{
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 40,height: 40)
                            VStack(alignment: .leading, spacing: 4){
                                Text("Kepin gans")
                                    .font(.title3)
                                HStack{
                                    Image(systemName: "trophy")
                                    Text("854")
                                }
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .padding(5)
                                .background(Color.blue)
                                .cornerRadius(6)
                            }
                            Spacer()
                            Text("Lose -24")
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding(7)
                            .padding(.horizontal,10)
                            .background(Color.red)
                            .cornerRadius(6)
                        }
                    }
                    .listStyle(.plain)
                }
            default:
                EmptyView()
            }
            
            Button{
                // play a match
            }label: {
                HStack{
                    Spacer()
                    Text("Play a match")
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                }
                .foregroundColor(Color.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(11)
            }
        }
        .padding()
        .background(Color("gray"))
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
