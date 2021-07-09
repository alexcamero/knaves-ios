//
//  MultiStart.swift
//  KnavesAux
//
//  Created by The Captain on 4/16/21.
//

import SwiftUI
import MultipeerConnectivity

struct MultiStart: View {
    
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
                    
                    Button("Play on Internet") {
                        player.requestOnlineGame()
                        player.state = .waitingRoom
                    }
                    .frame(width: buttonWidth(geo.size.width,geo.size.height), height: buttonHeight(geo.size.width,geo.size.height))
                    .background(Color.blue)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                    .cornerRadius(/*@START_MENU_TOKEN@*/16.0/*@END_MENU_TOKEN@*/)
                    
                    Button("Play on Local Network") {
                        player.localGameManager = MultiplayerManager(player: player, name: player.name)
                        player.state = .localMain
                    }
                    .frame(width: buttonWidth(geo.size.width,geo.size.height), height: buttonHeight(geo.size.width,geo.size.height))
                    .background(Color.blue)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                    .cornerRadius(/*@START_MENU_TOKEN@*/16.0/*@END_MENU_TOKEN@*/)
                    
                    Button("Back") {
                        player.state = .startUp
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

struct MultiStart_Previews: PreviewProvider {
    static var previews: some View {
        MultiStart()
            .environmentObject(HumanPlayer())
            .preferredColorScheme(.dark)
            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
                        .previewDisplayName("iPhone 12")
        
        MultiStart()
            .environmentObject(HumanPlayer())
            .previewLayout(.fixed(width: 844, height: 390))
                        .environment(\.horizontalSizeClass, .regular)
                        .environment(\.verticalSizeClass, .compact)
        
        MultiStart()
            .environmentObject(HumanPlayer())
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (4th generation)"))
                        .previewDisplayName("iPad Pro (12.9-inch) (4th generation)")
        
        MultiStart()
            .environmentObject(HumanPlayer())
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 1366, height: 1024))
                        .environment(\.horizontalSizeClass, .regular)
                        .environment(\.verticalSizeClass, .regular)
    }
}
