//
//  LocalGame.swift
//  KnavesAux
//
//  Created by The Captain on 4/23/21.
//

import SwiftUI
import MultipeerConnectivity



struct BrowseScreen: View {
    
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
                
                if geo.size.height > geo.size.width {
                    
                    VStack(alignment: .leading) {
                        
                        Text("Found Games")
                            .font(.title)
                            .padding([.leading, .bottom])
                        
                        ForEach(player.localGames) { game in
                            HStack {
                                Text(game.name)
                                Button("Join") {
                                    if let multiplayer = player.localGameManager {
                                        multiplayer.joinGame(game.mcid)
                                    }
                                }
                                .frame(width: buttonWidth(geo.size.width,geo.size.height)/2, height: buttonHeight(geo.size.width,geo.size.height)/2)
                                .background(Color.blue)
                                .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                                .cornerRadius(8)
                            }
                            .padding([.leading, .bottom])
                        }
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            Button("Back") {
                                player.localGameManager = nil
                                player.state = .multiStart
                            }
                            .frame(width: buttonWidth(geo.size.width,geo.size.height), height: buttonHeight(geo.size.width,geo.size.height))
                            .background(Color.blue)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                            .cornerRadius(/*@START_MENU_TOKEN@*/16.0/*@END_MENU_TOKEN@*/)
                            Spacer()
                            Button("Host Game") {
                                if let multiplayer = player.localGameManager {
                                    multiplayer.startHostingGame()
                                }
                            }
                            .frame(width: buttonWidth(geo.size.width,geo.size.height), height: buttonHeight(geo.size.width,geo.size.height))
                            .background(Color.blue)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                            .cornerRadius(/*@START_MENU_TOKEN@*/16.0/*@END_MENU_TOKEN@*/)
                            Spacer()
                        }
                        
                    }
                    
                } else {
                    
                    HStack {
                        
                        VStack(alignment: .leading) {
                            
                            Text("Found Games")
                                .font(.title)
                                .padding(.bottom)
                            
                            ForEach(player.localGames) { game in
                                HStack {
                                    Text(game.name)
                                    Button("Join") {
                                        if let multiplayer = player.localGameManager {
                                            multiplayer.joinGame(game.mcid)
                                            player.state = .localJoined
                                        }
                                    }
                                    .frame(width: buttonWidth(geo.size.width,geo.size.height)/2, height: buttonHeight(geo.size.width,geo.size.height)/2)
                                    .background(Color.blue)
                                    .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                                    .cornerRadius(8)
                                }
                                .padding([.leading, .bottom])
                            }
                            Spacer()
                        }
                        .padding([.top, .leading])
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            
                            Spacer()
                            Button("Back") {
                                player.localGameManager = nil
                                player.state = .startUp
                            }
                            .frame(width: buttonWidth(geo.size.width,geo.size.height), height: buttonHeight(geo.size.width,geo.size.height))
                            .background(Color.blue)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                            .cornerRadius(/*@START_MENU_TOKEN@*/16.0/*@END_MENU_TOKEN@*/)
                            Spacer()
                            Button("Host Game") {
                                if let multiplayer = player.localGameManager {
                                    multiplayer.startHostingGame()
                                    player.state = .localHost
                                }
                            }
                            .frame(width: buttonWidth(geo.size.width,geo.size.height), height: buttonHeight(geo.size.width,geo.size.height))
                            .background(Color.blue)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                            .cornerRadius(/*@START_MENU_TOKEN@*/16.0/*@END_MENU_TOKEN@*/)
                            Spacer()
                            
                        }
                        .padding(.trailing)
                    
                    }
                }
            }
        }
    }
}

struct LocalGame_Previews: PreviewProvider {
    static var previews: some View {
        BrowseScreen()
    }
}
