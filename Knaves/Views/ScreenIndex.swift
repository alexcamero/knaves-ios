//
//  ScreenIndex.swift
//  Knaves
//
//  Created by The Captain on 4/26/21.
//

import SwiftUI

struct ScreenIndex: View {
    
    @EnvironmentObject var player: HumanPlayer
    
    var body: some View {
        switch player.state {
            case .startUp:
                StartUp()
            case .multiStart:
                MultiStart()
            case .game:
                Table()
            case .settings:
                Settings()
            case .localMain:
                BrowseScreen()
            case .localHost:
                LocalHost()
            case .localJoined:
                LocalJoined()
            case .gameOver:
                GameOver()
            case .waitingRoom:
                WaitingRoom()
            default:
                StartUp()
        }
    }
}

struct ScreenIndex_Previews: PreviewProvider {
    static var previews: some View {
        ScreenIndex()
    }
}
