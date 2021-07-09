//
//  LocalJoined.swift
//  Knaves
//
//  Created by The Captain on 4/28/21.
//

import SwiftUI

struct LocalJoined: View {
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
                    if let host = player.hostID {
                        Text(host.displayName + "'s Game")
                        HStack {
                            Text("Player 1:")
                            Text(host.displayName)
                        }
                        HStack {
                            Text("Player 2:")
                            Text(player.name)
                        }
                        HStack {
                            Text("Player 3:")
                            if player.connectedPlayers.count > 1 {
                                if player.connectedPlayers[1] != host {
                                    Text(player.connectedPlayers[1].displayName)
                                } else {
                                    Text(player.connectedPlayers[0].displayName)
                                }
                            } else {
                                Text("AI Player")
                            }
                        }
                    } else {
                        Text("SOMETHING IS WRONG")
                    }
                    
                    
                    
                    Spacer()
                    
                    HStack {
                        Button("Back") {
                            if let multiplayer = player.localGameManager {
                                multiplayer.leaveGame()
                                
                            }
                            
                        }
                        .frame(width: buttonWidth(geo.size.width,geo.size.height), height: buttonHeight(geo.size.width,geo.size.height))
                        .background(Color.blue)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                        .cornerRadius(/*@START_MENU_TOKEN@*/16.0/*@END_MENU_TOKEN@*/)
                    }
                }
            }
        }
    }
}

struct LocalJoined_Previews: PreviewProvider {
    static var previews: some View {
        LocalJoined()
    }
}
