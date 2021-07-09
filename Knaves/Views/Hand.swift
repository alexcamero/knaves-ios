//
//  Hand.swift
//  Knaves
//
//  Created by The Captain on 3/24/21.
//

import SwiftUI

struct Hand: View {
    
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
    
    @EnvironmentObject var player: HumanPlayer
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    
    
    var body: some View {
        
        let cardHeight: CGFloat?
        
        if horizontalSizeClass == .compact {
            cardHeight = 175
        } else {
            cardHeight = 400
        }
        
        return ZStack {
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
                                    if value.translation.height < -200 {
                                        player.play(selectedCardIndex: i)
                                    } else {
                                        player.currentPositionOfCards[i] = .zero
                                    }
                                })
            }
        }
        
    }
}

struct Hand_Previews: PreviewProvider {
    static var previews: some View {
        Hand()
    }
}
