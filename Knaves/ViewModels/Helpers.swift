//
//  Helpers.swift
//  Knaves
//
//  Created by The Captain on 4/26/21.
//

import Foundation
import SwiftUI

let numberOfFaces = 34

extension Color {
    static let cards = Color("cardTable")
}

enum PossibleStates {
    case startUp
    case multiStart
    case game
    case settings
    case stats
    case localMain
    case localHost
    case localJoined
    case onlineMain
    case gameOver
    case waitingRoom
}


