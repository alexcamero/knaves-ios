//
//  Card.swift
//  Knaves
//
//  Created by The Captain on 3/24/21.
//

import Foundation

let suits = ["spades", "clubs", "diamonds", "hearts"]
let faces = ["jack", "queen", "king", "ace"]
let jokers = ["red_joker","black_joker"]

struct Card: Equatable, Comparable, Codable {
    var rank: Int
    var suit: Int
    
    var image: String {
        if suit < 0 || suit > 3 || rank < 2 || rank > 14 {
            return jokers.randomElement()!
        } else if rank >= 2 && rank <= 10 {
            return "\(rank)_of_\(suits[suit])"
        } else {
            return "\(faces[rank - 11])_of_\(suits[suit])"
        }
    }
    
    var description: String {
        if suit < 0 || suit > 3 || rank < 2 || rank > 14 {
            return "Jolly Joker"
        } else if rank >= 2 && rank <= 10 {
            return "\(rank) of \(suits[suit])"
        } else {
            return "\(faces[rank - 11]) of \(suits[suit])"
        }
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        if lhs.description == rhs.description {
            return true
        } else {
            return false
        }
    }
    
    static func < (lhs: Card, rhs: Card) -> Bool {
        if (lhs == rhs) || (lhs.description == "Jolly Joker") || (lhs.suit > rhs.suit) {
            return false
        } else if rhs.suit > lhs.suit {
            return true
        } else if rhs.rank > lhs.rank {
            return true
        } else {
            return false
        }
    }
}

func shuffledDeck(includeJokers: Bool) -> [Card] {
    // Returns a shuffled deck of all 52 cards with optional jokers
    
    var deck: [Card] = []
    for s in 0...3 {
        for r in 2...14 {
            deck.append(Card(rank: r, suit: s))
        }
    }
    if includeJokers {
        deck.append(Card(rank: 0, suit: -1))
        deck.append(Card(rank: -1, suit: -1))
    }
    
    deck.shuffle()
    return deck
}
