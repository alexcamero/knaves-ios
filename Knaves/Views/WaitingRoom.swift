//
//  WaitingRoom.swift
//  Knaves
//
//  Created by The Captain on 5/14/21.
//

import SwiftUI

struct WaitingRoom: View {
    @EnvironmentObject var player: HumanPlayer
    @State var rot = 0.0
    private let animation = Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)
    
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
                    
                    Text("Finding other players...")
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
                        withAnimation(self.animation) {
                            rot = 20
                                    }
                                }
                    
                    
                    Spacer()
                    
                    HStack {
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
                        
                        Spacer()
                        
                        VStack {
                            if let opp1 = player.opponentUID1 {
                                if player.onlinePlayerDetails[opp1]!["face"] as! Int == -1 {
                                    (player.onlinePlayerDetails[opp1]!["image"] as! Image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 90, height: 90)
                                        .clipped()
                                } else {
                                    Image("face\(player.onlinePlayerDetails[opp1]!["face"] as! Int)")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 90, height: 90)
                                        .clipped()
                                }
                                
                                Text(player.onlinePlayerDetails[opp1]!["name"] as! String)
                                
                            } else {
                                Image("question")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 90, height: 90)
                                    .clipped()
                                
                                Text("Player 2")
                            }
                        }
                        
                        Spacer()
                        
                        VStack {
                            if let opp2 = player.opponentUID2 {
                                if player.onlinePlayerDetails[opp2]!["face"] as! Int == -1 {
                                    (player.onlinePlayerDetails[opp2]!["image"] as! Image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 90, height: 90)
                                        .clipped()
                                } else {
                                    Image("face\(player.onlinePlayerDetails[opp2]!["face"] as! Int)")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 90, height: 90)
                                        .clipped()
                                }
                                
                                Text(player.onlinePlayerDetails[opp2]!["name"] as! String)
                                
                            } else {
                                Image("question")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 90, height: 90)
                                    .clipped()
                                
                                Text("Player 3")
                            }
                        }
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    Button("Cancel") {
                        player.state = .startUp
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

struct WaitingRoom_Previews: PreviewProvider {
    static var previews: some View {
        WaitingRoom()
    }
}
