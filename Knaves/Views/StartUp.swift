//
//  StartUp.swift
//  Knaves
//
//  Created by The Captain on 4/10/21.
//

import SwiftUI


struct StartUp: View {
    
    
    @EnvironmentObject var player: HumanPlayer
    @State var rot = 0.0
    
    
    
    func cardWidth(_ width: CGFloat, _ height: CGFloat) -> CGFloat {
        if width > 975 {
            if width > height {
                return width/7
            } else {
                return width/4
            }
        } else {
            if width > height {
                return width/10
            } else {
                return width/3.5
            }
        }
    }
    
    func buttonWidth(_ width: CGFloat, _ height: CGFloat) -> CGFloat {
        if width > 975 {
            if width > height {
                return width/7
            } else {
                return width/4
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
                return width/7
            }
        } else {
            if width > height {
                return width/12
            } else {
                return width/3.5
            }
        }
    }

    var body: some View {
        
        GeometryReader { geo in
            ZStack {
                Color.cards.ignoresSafeArea()
                
                VStack {
                    
                    Spacer()
                    
                    Text("Knaves")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    ZStack {
                        Image("jack_of_spades2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: cardWidth(geo.size.width,geo.size.height))
                            .rotationEffect(Angle(degrees: 0 - 2*rot), anchor: .bottom)
                            
                        
                        Image("jack_of_clubs2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: cardWidth(geo.size.width,geo.size.height))
                            .rotationEffect(Angle(degrees: 0 - rot), anchor: .bottom)
                            
                        
                        Image("jack_of_diamonds2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: cardWidth(geo.size.width,geo.size.height))
                            .rotationEffect(Angle(degrees: 0 + rot), anchor: .bottom)
                            
                        
                        Image("jack_of_hearts2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: cardWidth(geo.size.width,geo.size.height))
                            .rotationEffect(Angle(degrees: 0 + 2*rot), anchor: .bottom)
                            
                    }
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 0.5)) {
                            rot = 20
                                    }
                        player.resetGameConditions()
                                }
                    
                    
                    Spacer()
                    
                    if geo.size.height > geo.size.width {
                        HStack {
                            Spacer()
                            VStack {
                                Spacer()
                                Button("Solo Game") {
                                    withAnimation(Animation.easeInOut(duration: 0.25)){
                                        rot = 0
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now()+0.20) {
                                        player.game = KnavesGame(knavesPlayers: [player,RandomPlayer(),RandomPlayer()])
                                        player.game!.newHand()
                                        player.state = .game
                                    }
                                }
                                .frame(width: buttonWidth(geo.size.width,geo.size.height), height: buttonHeight(geo.size.width,geo.size.height))
                                .background(Color.blue)
                                .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                                .cornerRadius(/*@START_MENU_TOKEN@*/16.0/*@END_MENU_TOKEN@*/)
                                Spacer()
                                Button("Settings") {
                                    withAnimation(Animation.easeInOut(duration: 0.25)){
                                        rot = 0
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now()+0.20) {
                                        player.state = .settings
                                    }
                                    
                                    
                                }
                                .frame(width: buttonWidth(geo.size.width,geo.size.height), height: buttonHeight(geo.size.width,geo.size.height))
                                .background(Color.blue)
                                .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                                .cornerRadius(/*@START_MENU_TOKEN@*/16.0/*@END_MENU_TOKEN@*/)
                                Spacer()
                            }
                            Spacer()
                            VStack {
                                Spacer()
                                Button("Online Game") {
                                    withAnimation(Animation.easeInOut(duration: 0.25)){
                                        rot = 0
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now()+0.20) {
                                        player.state = .multiStart
                                    }
                                }
                                .frame(width: buttonWidth(geo.size.width,geo.size.height), height: buttonHeight(geo.size.width,geo.size.height))
                                .background(Color.blue)
                                .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                                .cornerRadius(/*@START_MENU_TOKEN@*/16.0/*@END_MENU_TOKEN@*/)
                                Spacer()
                                Button("Statistics") {
                                    withAnimation(Animation.easeInOut(duration: 0.25)){
                                        rot = 0
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now()+0.20) {
                                        player.state = .stats
                                    }
                                }
                                .frame(width: buttonWidth(geo.size.width,geo.size.height), height: buttonHeight(geo.size.width,geo.size.height))
                                .background(Color.blue)
                                .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                                .cornerRadius(/*@START_MENU_TOKEN@*/16.0/*@END_MENU_TOKEN@*/)
                                Spacer()
                            }
                            Spacer()
                        }
                    } else {
                        HStack {
                            Spacer()
                            Button("Solo Game") {
                                player.game = KnavesGame(knavesPlayers: [player,RandomPlayer(),RandomPlayer()])
                                withAnimation(Animation.easeInOut(duration: 0.25)){
                                    rot = 0
                                }
                                player.game!.newHand()
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.20) {
                                    player.state = .game
                                }
                            }
                            .frame(width: buttonWidth(geo.size.width,geo.size.height), height: buttonHeight(geo.size.width,geo.size.height))
                            .background(Color.blue)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                            .cornerRadius(/*@START_MENU_TOKEN@*/16.0/*@END_MENU_TOKEN@*/)
                            Spacer()
                            Button("Settings") {
                                withAnimation(Animation.easeInOut(duration: 0.25)){
                                    rot = 0
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.20) {
                                    player.state = .settings
                                }
                            }
                            .frame(width: buttonWidth(geo.size.width,geo.size.height), height: buttonHeight(geo.size.width,geo.size.height))
                            .background(Color.blue)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                            .cornerRadius(/*@START_MENU_TOKEN@*/16.0/*@END_MENU_TOKEN@*/)
                            Spacer()
                            Button("Online Game") {
                                withAnimation(Animation.easeInOut(duration: 0.25)){
                                    rot = 0
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.20) {
                                    player.state = .multiStart
                                }
                            }
                            .frame(width: buttonWidth(geo.size.width,geo.size.height), height: buttonHeight(geo.size.width,geo.size.height))
                            .background(Color.blue)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                            .cornerRadius(/*@START_MENU_TOKEN@*/16.0/*@END_MENU_TOKEN@*/)
                            Spacer()
                            Button("Statistics") {
                                withAnimation(Animation.easeInOut(duration: 0.25)){
                                    rot = 0
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.20) {
                                    player.state = .stats
                                }
                            }
                            .frame(width: buttonWidth(geo.size.width,geo.size.height), height: buttonHeight(geo.size.width,geo.size.height))
                            .background(Color.blue)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                            .cornerRadius(/*@START_MENU_TOKEN@*/16.0/*@END_MENU_TOKEN@*/)
                            Spacer()
                        }
                    }
                    
                    Spacer()
                    
                    
                    
                }
            }
        }
    }
}

struct StartUp_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            
            StartUp()
                .environmentObject(HumanPlayer())
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
                            .previewDisplayName("iPhone 12")
            
            StartUp()
                .environmentObject(HumanPlayer())
                .previewLayout(.fixed(width: 844, height: 390))
                            .environment(\.horizontalSizeClass, .regular)
                            .environment(\.verticalSizeClass, .compact)
            
            StartUp()
                .environmentObject(HumanPlayer())
                .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (4th generation)"))
                            .previewDisplayName("iPad Pro (12.9-inch) (4th generation)")
            
            StartUp()
                .environmentObject(HumanPlayer())
                .preferredColorScheme(.dark)
                .previewLayout(.fixed(width: 1366, height: 1024))
                            .environment(\.horizontalSizeClass, .regular)
                            .environment(\.verticalSizeClass, .regular)
            
        }
    }
}
