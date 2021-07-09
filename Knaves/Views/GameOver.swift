//
//  GameOver.swift
//  Knaves
//
//  Created by The Captain on 4/26/21.
//

import SwiftUI

struct GameOver: View {
    
    @EnvironmentObject var player: HumanPlayer
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                VStack {
                    Text(player.players[0])
                        .font(.headline)
                    Text("\(player.score[0])")
                }
                
                Spacer()
                
                VStack {
                    Text(player.players[1])
                        .font(.headline)
                    Text("\(player.score[1])")
                }
                
                Spacer()
                
                VStack {
                    Text(player.players[2])
                        .font(.headline)
                    Text("\(player.score[2])")
                }
                
                Spacer()
                
            }
            Spacer()
            Text(player.gameEndMessage1)
                .font(.headline)
            Text(player.gameEndMessage2)
                .font(.subheadline)
            Spacer()
            HStack {
                Button("Play Again") {

                }
                
                Button("Home") {
                    player.localGameManager = nil
                    player.state = .startUp
                }
            }
            Spacer()
        }
    }
}

struct GameOver_Previews: PreviewProvider {
    static var previews: some View {
        GameOver()
    }
}
