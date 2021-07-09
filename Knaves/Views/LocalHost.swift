//
//  LocalHost.swift
//  Knaves
//
//  Created by The Captain on 4/26/21.
//

import SwiftUI

struct LocalHost: View {
    
    @EnvironmentObject var player: HumanPlayer
    
    func buttonWidth(_ width: CGFloat, _ height: CGFloat) -> CGFloat {
        if width > 975 {
            if width > height {
                return width/7
            } else {
                return width/6
            }
        } else {
            if width > height {
                return width/7
            } else {
                return width/3.5
            }
        }
    }
    
    func buttonHeight(_ width: CGFloat, _ height: CGFloat) -> CGFloat {
        if width > 975 {
            if width > height {
                return width/11
            } else {
                return width/10
            }
        } else {
            if width > height {
                return width/12
            } else {
                return width/7
            }
        }
    }
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.cards.ignoresSafeArea()
                
                VStack {
                    Text(player.name + "'s Game")

                    HStack {
                        Text("Player 1:")
                        Text(player.name)
                    }
                    
                    HStack {
                        Text("Player 2:")
                        if player.connectedPlayers.count > 0 {
                            Text(player.connectedPlayers[0].displayName)
                        } else {
                            Text("Computer Player")
                        }
                    }

                    
                    HStack {
                        Text("Player 3:")
                        if player.connectedPlayers.count > 1 {
                            Text(player.connectedPlayers[1].displayName)
                        } else {
                            Text("Computer Player")
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Button("Back") {
                            if let multiplayer = player.localGameManager {
                                multiplayer.stopHostingGame()
                                player.state = .localMain
                            }
                            
                        }
                        .frame(width: buttonWidth(geo.size.width,geo.size.height), height: buttonHeight(geo.size.width,geo.size.height))
                        .background(Color.blue)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                        .cornerRadius(/*@START_MENU_TOKEN@*/16.0/*@END_MENU_TOKEN@*/)
                        Spacer()
                        Button("Start Game") {
                            if let multiplayer = player.localGameManager {
                                multiplayer.startGame()
                            }
                        }
                        .frame(width: buttonWidth(geo.size.width,geo.size.height), height: buttonHeight(geo.size.width,geo.size.height))
                        .background(Color.blue)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                        .cornerRadius(/*@START_MENU_TOKEN@*/16.0/*@END_MENU_TOKEN@*/)
                        Spacer()
                    }
                }
            }
        }
    }
}

struct LocalHost_Previews: PreviewProvider {
    static var previews: some View {
        LocalHost()
    }
}
