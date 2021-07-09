//
//  Table.swift
//  Knaves
//
//  Created by The Captain on 3/26/21.
//

import SwiftUI

struct Table: View {
    
    @EnvironmentObject var player: HumanPlayer
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    
    let leftStart = CGSize(width: -100, height: -150)
    let rightStart = CGSize(width: 100, height: -150)
    let bottomStart = CGSize(width: 0, height: 0)


    
    func angle(_ index: Int, _ total: Int, _ sizeClass:UserInterfaceSizeClass?) -> Double {
        /// Fans the cards
        let mp = Double(total)/2.0
        if sizeClass == .compact {
            return 8.0 * (Double(index) - mp)
        } else {
            return Double(0)
        }
    }
    
    func noFan(_ index: Int, _ total: Int, _ sizeClass:UserInterfaceSizeClass?) -> CGFloat {
        let mp = Double(total)/2.0
        if sizeClass != .compact {
            return CGFloat(40.0 * (Double(index) - mp))
        } else {
            return CGFloat(0)
        }
    }
    
    var body: some View {
        
        let cardHeight: CGFloat?
        let cardHeightPlayed: CGFloat?
        let pad: CGFloat?
        let hOff: CGFloat
        let vOff: CGFloat
        let moveCard: CGFloat
        let handOffset: CGFloat
        var rotateTrump = false
        
        if horizontalSizeClass == .compact {
            cardHeight = 150
            cardHeightPlayed = 150
            pad = 300
            vOff = 100
            hOff = 75
            moveCard = -200
            handOffset = 0
        } else if verticalSizeClass == .compact {
            rotateTrump = true
            cardHeight = 150
            cardHeightPlayed = 115
            pad = 200
            vOff = 60
            hOff = 60
            moveCard = -50
            handOffset = 40
        } else {
            cardHeight = 400
            cardHeightPlayed = 250
            pad = 400
            vOff = 150
            hOff = 100
            moveCard = -200
            handOffset = 75
        }
        
        
        let leftOffset = CGSize(width: -hOff, height: -vOff)
        let rightOffset = CGSize(width: hOff, height: -vOff)
        let bottomOffset = CGSize(width: 0, height: vOff)

        
        return GeometryReader { geo in
            ZStack {
                Color.cards.ignoresSafeArea()
                
                VStack {
                    
                    HStack {
                        Button("< Back") {
                            player.state = .startUp
                        }
                        .padding(.leading)
                        
                        Spacer()
                        
                        if rotateTrump {
                            Image(player.trumpCard.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 72.6)
                                .rotationEffect(Angle(degrees: 90), anchor: .center)
                                .padding(.trailing)
                            
                        } else {
                            Image(player.trumpCard.image)
                                .resizable()
                                .frame(width: 50, height: 72.6)
                                .scaledToFit()
                                .padding(.trailing)
                        }
                        
                    }
                    
                    Divider()
                    
                    HStack {
                        HStack {
                            ZStack {
                                if player.currentPlayer == (player.position + 1) % 3 {
                                    Rectangle()
                                        .fill(Color.blue)
                                        .frame(width: 60, height: 60)
                                } else {
                                    Rectangle()
                                        .fill(Color.cards.opacity(0.0))
                                        .frame(width: 60, height: 60)
                                }
                                Image("face\(player.playerFaces[(player.position + 1) % 3])")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipped()
                            }
            
                            VStack {
                                Text(player.players[(player.position + 1) % 3])
                                    .font(.headline)
                                Text("\(player.score[(player.position + 1) % 3])")
                            }
                        }
                        .padding(.leading)
                        
                        
                        Spacer()
                        
                        HStack {
                            ZStack {
                                if player.currentPlayer == (player.position + 2) % 3 {
                                    Rectangle()
                                        .fill(Color.blue)
                                        .frame(width: 60, height: 60)
                                } else {
                                    Rectangle()
                                        .fill(Color.cards.opacity(0.0))
                                        .frame(width: 60, height: 60)
                                }
                                Image("face\(player.playerFaces[(player.position + 2) % 3])")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipped()
                            }
            
                            VStack {
                                Text(player.players[(player.position + 2) % 3])
                                    .font(.headline)
                                Text("\(player.score[(player.position + 2) % 3])")
                            }
                        }
                        .padding(.trailing)
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Rectangle()
                            .fill(Color.cards.opacity(0.0))
                            .frame(width: pad, height: pad)

                        if let leftCard = player.cardL {
                            Image(leftCard.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: cardHeightPlayed)
                            .rotationEffect(Angle(degrees: -30), anchor: .bottom)
                                .offset(x: leftOffset.width + player.leftAnimationOffset.width, y: leftOffset.height + player.leftAnimationOffset.height)
                                .onAppear {
                                    withAnimation(Animation.easeInOut(duration: 0.25)) {
                                        player.leftAnimationOffset = CGSize(width: 0, height: 0)
                                    }
                                }
                                .onDisappear {
                                    player.leftAnimationOffset = leftStart
                                }
                            
                        }

                        if let rightCard = player.cardR {
                            Image(rightCard.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: cardHeightPlayed)
                            .rotationEffect(Angle(degrees: 30), anchor: .bottom)
                                .offset(x: rightOffset.width + player.rightAnimationOffset.width, y: rightOffset.height + player.rightAnimationOffset.height)
                                .onAppear {
                                    withAnimation(Animation.easeInOut(duration: 0.25)) {
                                        player.rightAnimationOffset = CGSize(width: 0, height: 0)
                                    }
                                }
                                .onDisappear {
                                    player.rightAnimationOffset = rightStart
                                }
                        }
                        
                        if let bottomCard = player.myCard {
                            Image(bottomCard.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: cardHeightPlayed)
                            .offset(x: bottomOffset.width + player.bottomAnimationOffset.width, y: bottomOffset.height + player.bottomAnimationOffset.height)
                                .onDisappear {
                                    player.bottomAnimationOffset = bottomStart
                                }
                        }

                    }
                    .offset(y: handOffset/2)
                    
                    Spacer()
                    
                    HStack {
                        ZStack {
                            if player.currentPlayer == player.position {
                                Rectangle()
                                    .fill(Color.blue)
                                    .frame(width: 60, height: 60)
                            } else {
                                Rectangle()
                                    .fill(Color.cards.opacity(0.0))
                                    .frame(width: 60, height: 60)
                            }
                            if player.face == -1 {
                                player.image!
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                    .clipped()
                            } else {
                                Image("face\(player.face)")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                    .clipped()
                            }
                            
                        }
                        
                        VStack {
                        
                            Text(player.name)
                                .font(.headline)
                            Text("\(player.score[player.position])")
                        }
                    }
                    
                    ZStack {
                        
                        Rectangle()
                            .foregroundColor(Color.cards.opacity(0.0))
                            .frame(width: 200, height: cardHeight)
                        
                        ForEach(0..<player.hand.count, id: \.self) { i in
                            Image(player.hand[i].image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: cardHeight)
                                .rotationEffect(Angle(degrees: angle(i,player.hand.count,horizontalSizeClass)), anchor: .bottom)
                                .offset(x: player.currentPositionOfCards[i].width + noFan(i,player.hand.count,horizontalSizeClass), y: player.currentPositionOfCards[i].height)
                                .gesture(DragGesture()
                                            .onChanged { value in
                                                player.currentPositionOfCards[i] = CGSize(width: value.translation.width, height: value.translation.height)}
                                            .onEnded { value in
                                                if (value.translation.height < moveCard) && player.ableToMove {
                                                    player.play(selectedCardIndex: i)
                                                } else {
                                                    player.currentPositionOfCards[i] = .zero
                                                }
                                            })
                        }
                    }
                    .offset(y: handOffset)
                }
            }
        }
    }
}

struct Table_Previews: PreviewProvider {

    
    static var previews: some View {
        Table()
    }
}
