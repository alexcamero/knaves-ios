//
//  KnavesGame.swift
//  Knaves
//
//  Created by The Captain on 3/24/21.
//

import Foundation

protocol KGame {
    var players: [KnavesPlayer] { get set }
    func move(card: Card)
    func newHand()
}

class KnavesGame: KGame, ObservableObject {
    /// Sets up a game of Knaves with given players that conform to KnavesPlayer protocol
    
    var players: [KnavesPlayer]
    var playerNames: [String] = []
    var playerFaces: [Int] = []
    var playerScores = [0,0,0]
    var gameOver = false
    var startingPlayer = 0
    var currentPlayer = 0
    
    var trickWinner: Int = -1
    var trumpCard: Card = Card(rank: -1, suit: -1)
    var handScores = [0,0,0]
    var playerHands: [[Card]] = [[],[],[]]
    var currentTrick: [Card] = []
    
    func newHand() {
        if gameOver {
            let winScore = playerScores.max()
            var winner: [Int] = []
            for i in 0..<3 {
                if playerScores[i] == winScore {
                    winner.append(i)
                }
            }
            for i in 0..<3 {
                players[i].receiveResult(finalScores: playerScores, winnerIndex: winner)
            }
        } else {
            let newDeck = shuffledDeck(includeJokers: false)
            trumpCard = newDeck[0]
            playerHands = [Array(newDeck[1...17]), Array(newDeck[18...34]), Array(newDeck[35...51])]
            
            for i in 0..<3 {
                players[i].receiveHand(hand: playerHands[i], trumpCard: trumpCard)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                for i in 0..<3 {
                    self.players[i].move(self.startingPlayer)
                }
            }
            
        }
    }
    
    func move(card: Card) {
        currentTrick.append(card)
        playerHands[currentPlayer] = playerHands[currentPlayer].filter { $0 != card }
        for j in 0..<3 {
            players[j].receiveBroadcast(playerPosition: currentPlayer, cardPlayed: card)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.nextStep()
        }
    }
    
    func nextStep() {
        if currentTrick.count == 3 {
            trickWinner = (currentPlayer + 1 + winner(currentTrick, trumpCard.suit)) % 3
            for j in 0..<3 {
                players[j].receiveBroadcast(playerPosition: trickWinner, cardPlayed: nil)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.reset()
            }
        } else {
            currentPlayer = (currentPlayer + 1) % 3
            for i in 0..<3 {
                players[i].move(currentPlayer)
            }
            
        }
    }
    
    func reset() {
        handScores[trickWinner] += evaluate(currentTrick)
        currentTrick = []
        if playerHands[currentPlayer].count == 0 {
            for j in 0..<3 {
                players[j].receiveHandScores(handScores)
            }
            for j in 0..<3 {
                playerScores[j] += handScores[j]
                handScores[j] = 0
                if playerScores[j] >= 20 {
                    gameOver = true
                }
            }
            startingPlayer = (startingPlayer + 1) % 3
            currentPlayer = startingPlayer
            newHand()
        } else {
            currentPlayer = trickWinner
            for i in 0..<3 {
                players[i].move(currentPlayer)
            }
        }
    }
    
    func evaluate(_ threeCards: [Card]) -> Int {
        /// Takes a  three-card trick and returns its value to the player taking it
        var value = 1
        for card in threeCards {
            if card.rank == 11 {
                value = value - 1 - card.suit
            }
        }
        return value
    }
    
    func winner(_ threeCards: [Card], _ trumpSuit: Int) -> Int {
        /// Takes a three-card trick in order of play and the trump suit and returns the position of the winning card from the input array
        var win = 0
        var winCard = threeCards[0]
        var newCard: Card
        
        for i in 1...2 {
            newCard = threeCards[i]
            if ((newCard.suit == winCard.suit) && (newCard.rank > winCard.rank)) || ((newCard.suit == trumpSuit) && (winCard.suit != trumpSuit)) {
                win = i
                winCard = newCard
            }
        }
        return win
    }
    
    
    init(knavesPlayers: [KnavesPlayer]) {
        players = knavesPlayers
        players.shuffle()
        for i in 0..<3 {
            players[i].game = self
            playerNames.append(players[i].name)
            playerFaces.append(players[i].face)
        }
        for i in 0..<3 {
            players[i].receivePlayerNames(position: i, names: playerNames, faces: playerFaces)
        }
    }
}
