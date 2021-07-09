//
//  Settings.swift
//  Knaves
//
//  Created by The Captain on 4/26/21.
//

import SwiftUI

struct Settings: View {
    
    @EnvironmentObject var player: HumanPlayer
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.cards.ignoresSafeArea()
                
                VStack {
                    
                    HStack {
                        Button("<Back") {
                            player.ref.child("users/\(player.uid)/username").setValue(player.name)
                            player.ref.child("users/\(player.uid)/userface").setValue(player.face)
                            player.state = .startUp
                        }
                        
                        Spacer()
                        
                        VStack {
                            if player.face == -1 {
                                player.image!
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 90, height: 90)
                                    .clipped()
                            } else {
                                Image("face\(player.face)")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 90, height: 90)
                                    .clipped()
                            }
                            
                            Text(player.name)
                        }
                    }
                    
                    HStack {
                        Text("Name:")
                        TextField("Enter your name", text: $player.name)
                    }
                    
                    Text("Select a Face")
                    
                    ScrollView {
                        ForEach(0..<numberOfFaces/3 + 1) { i in
                            HStack {
                                ForEach(1..<4) { j in
                                    ZStack {
                                        if player.face == 3*i + j {
                                            Rectangle()
                                                .fill(Color.blue)
                                                .frame(width: 100, height: 100)
                                        } else {
                                            Rectangle()
                                                .fill(Color.cards.opacity(0.0))
                                                .frame(width: 100, height: 100)
                                        }
                                        Image("face\(3*i + j)")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 90, height: 90)
                                            .clipped()
                                            .gesture(TapGesture()
                                                        .onEnded{_ in
                                                            player.face = 3*i + j
                                                        })
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
            .environmentObject(HumanPlayer())
    }
}
