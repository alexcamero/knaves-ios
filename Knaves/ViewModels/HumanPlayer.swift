//
//  HumanPlayer.swift
//  Knaves
//
//  Created by The Captain on 3/26/21.
//

import Foundation
import SwiftUI
import MultipeerConnectivity
import GameKit
import Firebase
import FirebaseFunctions
import FirebaseStorage

class HumanPlayer: KnavesPlayer, ObservableObject {
    
    @Published var name: String = randomNames.randomElement()!
    @Published var face = Int.random(in: 1..<numberOfFaces+1)
    @Published var hand: [Card] = []
    @Published var currentPositionOfCards: [CGSize] = []
    @Published var trumpCard: Card = Card(rank: -1, suit: -1)
    @Published var players: [String] = []
    @Published var playerFaces: [Int] = []
    @Published var score: [Int] = [0,0,0]
    @Published var cardL: Card?
    @Published var cardR: Card?
    @Published var myCard: Card?
    @Published var ableToMove = false
    @Published var gameEndMessage1 = "???"
    @Published var gameEndMessage2 = "???"
    @Published var state: PossibleStates = .startUp
    @Published var currentPlayer = 0
    @Published var leftAnimationOffset = CGSize(width: -100, height: -150)
    @Published var rightAnimationOffset = CGSize(width: 100, height: -150)
    @Published var bottomAnimationOffset = CGSize(width: 0, height: 0)
    
    var position: Int = -1
    var game: KGame?
    @Published var localGameManager: MultiplayerManager?
    @Published var localGames: [HostedGame] = []
    @Published var connectedPlayers: [MCPeerID] = []
    @Published var hostID: MCPeerID?
    @Published var image: Image?
    var imageData: Data?
    @Published var points: Int = 0
    
    let localPlayer = GKLocalPlayer.local
    var ref: DatabaseReference!
    var functions: Functions
    let storage: Storage
    var uid: String = ""
    var room: String = ""
    @Published var onlinePlayerDetails: [String: [String:Any]] = ["":["":""]]
    @Published var opponentUID1: String?
    @Published var opponentUID2: String?
    
    init() {
        FirebaseApp.configure()
        ref = Database.database().reference()
        storage = Storage.storage()
        functions = Functions.functions()
        authenticateUser()
    }
    
    func authenticateUserTemp() {
        Auth.auth().signInAnonymously() { (authResult, error) in
            if error != nil {
                print("uh oh")
                print(error?.localizedDescription ?? "")
                return
            }
            guard let user = authResult?.user else { return }
            self.uid = user.uid
            self.ref.child("users/\(self.uid)/username").getData { (error, snapshot) in
                if let error = error {
                    print("Error getting data \(error)")
                    return
                }
                if snapshot.exists() {
                    if let username = snapshot.value {
                        DispatchQueue.main.async{
                            self.name = "\(username)"
                        }
                    }
                } else {
                    self.ref.child("users/\(self.uid)/username").setValue(self.name)
                }
            }
        }
    }
    
    func authenticateUser() {
        localPlayer.authenticateHandler = { vc, error in
            guard error == nil else { 
                print(error?.localizedDescription ?? "")
                return
            }
            GKAccessPoint.shared.isActive = self.localPlayer.isAuthenticated
            self.name = self.localPlayer.displayName
            self.localPlayer.loadPhoto(for: .small) {(image, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "There was an error with the picture loading")
                } else if let pic = image {
                    self.image = Image(uiImage: pic)
                    self.face = -1
                    self.imageData = pic.jpegData(compressionQuality: 0.75)
                }
            }

            // Get Firebase credentials from the player's Game Center credentials
            GameCenterAuthProvider.getCredential() { (credential, error) in
              if error != nil {
                print(error?.localizedDescription ?? "There was an error with google")
                return
              }
                // The credential can be used to sign in, or re-auth, or link or unlink.
                Auth.auth().signIn(with:credential!) { (user, error) in
                    if error != nil {
                        print("There was an error with google 2")
                        print(error?.localizedDescription ?? "There was an error with google 2")
                        return
                    } else {
                        if let user = user {
                            self.uid = user.user.uid
                            
                            self.ref.child("users/\(self.uid)/username").getData { (error, snapshot) in
                                if let error = error {
                                    print("Error getting username data for the user: \(error)")
                                }
                                else if snapshot.exists() {
                                    if let username = snapshot.value as? String {
                                        DispatchQueue.main.async{
                                            self.name = username
                                        }
                                    }
                                } else {
                                    self.ref.child("users/\(self.uid)/username").setValue(self.name)
                                }
                            }
                            
                            self.ref.child("users/\(self.uid)/points").getData { (error, snapshot) in
                                if let error = error {
                                    print("Error getting points data for the user: \(error)")
                                }
                                else if snapshot.exists() {
                                    if let points = snapshot.value as? Int {
                                        DispatchQueue.main.async{
                                            self.points = points
                                        }
                                    }
                                } else {
                                    self.ref.child("users/\(self.uid)/points").setValue(self.points)
                                }
                            }
                            
                            self.ref.child("users/\(self.uid)/userface").getData { (error, snapshot) in
                                if let error = error {
                                    print("Error getting userface data for the user: \(error)")
                                }
                                else if snapshot.exists() {
                                    if let face = snapshot.value as? Int {
                                        DispatchQueue.main.async{
                                            self.face = face
                                        }
                                    }
                                } else {
                                    self.ref.child("users/\(self.uid)/userface").setValue(self.face)
                                    if self.face == -1 {
                                        let userimageRef = self.storage.reference().child("userimages/\(self.uid).jpeg")
                                        userimageRef.putData(self.imageData!, metadata: nil) { (metadata, error) in
                                            if error != nil {
                                                print("Error with image upload: \(error!)")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func receiveHand(hand: [Card], trumpCard: Card) {
        currentPositionOfCards = [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero]
        self.hand = hand
        self.trumpCard = trumpCard
        self.hand.sort()
        let spades = self.hand.filter { $0.suit == 0}
        let clubs = self.hand.filter { $0.suit == 1}
        let diamonds = self.hand.filter { $0.suit == 2}
        let hearts = self.hand.filter { $0.suit == 3}
        if self.trumpCard.suit == 0 {
            self.hand = diamonds + clubs + hearts + spades
        } else if self.trumpCard.suit == 1 {
            self.hand = diamonds + spades + hearts + clubs
        } else if trumpCard.suit == 2 {
            self.hand = spades + hearts + clubs + diamonds
        } else {
            self.hand = spades + diamonds + clubs + hearts
        }
    }
    
    func receiveResult(finalScores: [Int], winnerIndex: [Int]) {
        score = finalScores
        if winnerIndex.contains(position) {
            gameEndMessage1 = "Congratulations! You won!"
        } else {
            gameEndMessage1 = "Game over."
        }
        if winnerIndex.count == 1 {
            gameEndMessage2 = "\(players[winnerIndex[0]]) is the Knaves champion today."
        } else if winnerIndex.count == 2 {
            gameEndMessage2 = "\(players[winnerIndex[0]]) and \(players[winnerIndex[1]]) tied."
        } else if winnerIndex.count == 3 {
            gameEndMessage2 = "Well...everyone won. Three-way tie!"
        }
        state = .gameOver
    }
    
    func receiveBroadcast(playerPosition: Int, cardPlayed: Card?) {
        
        if let card = cardPlayed {
            if playerPosition == (position + 1) % 3 {
                cardL = card
            } else if playerPosition == (position + 2) % 3 {
                cardR = card
            } else {
                myCard = card
            }
        } else {
            if playerPosition == position {
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                    leftAnimationOffset = CGSize(width: 0, height: 1000)
                    rightAnimationOffset = CGSize(width: 0, height: 1000)
                    bottomAnimationOffset = CGSize(width: 0, height: 1000)
                }
            } else if playerPosition == (position + 1) % 3 {
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                    leftAnimationOffset = CGSize(width: -1000, height: 0)
                    rightAnimationOffset = CGSize(width: -1000, height: 0)
                    bottomAnimationOffset = CGSize(width: -1000, height: 0)
                }
            } else if playerPosition == (position + 2) % 3 {
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                    leftAnimationOffset = CGSize(width: 1000, height: 0)
                    rightAnimationOffset = CGSize(width: 1000, height: 0)
                    bottomAnimationOffset = CGSize(width: 1000, height: 0)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.cardL = nil
                self.cardR = nil
                self.myCard = nil
            }
        }  
    }
    
    func receiveHandScores(_ handScores: [Int]) {
        for i in 0...2 {
            score[i] += handScores[i]
        }
    }
    
    func move(_ position: Int) {
        self.currentPlayer = position
        if self.position == position {
            ableToMove = true
        }
    }
    
    func play(selectedCardIndex: Int) {
        ableToMove = false
        let playedCard = hand[selectedCardIndex]
        hand.remove(at: selectedCardIndex)
        currentPositionOfCards.remove(at: selectedCardIndex)
        game!.move(card: playedCard)
    }
    
    func receivePlayerNames(position: Int, names: [String], faces: [Int]) {
        self.position = position
        self.players = names
        self.playerFaces = faces
        self.state = .game
    }
    
    func resetGameConditions() {
        state = .startUp
        game = nil
        score = [0,0,0]
        cardL = nil
        cardR = nil
        myCard = nil
        hand = []
        currentPositionOfCards = []
        trumpCard = Card(rank: -1, suit: -1)
        players = []
        playerFaces = []
        ableToMove = false
        gameEndMessage1 = "???"
        gameEndMessage2 = "???"
        currentPlayer = 0
        position = -1
        game = nil
        hostID = nil
        localGameManager = nil
        localGames = []
        connectedPlayers = []
    }
    
    func requestOnlineGame() {
        functions.httpsCallable("gameRequest").call() { (result, error) in
          if let error = error as NSError? {
            print(error.localizedDescription)
            return
          }
            if let data = result?.data as? [String: String], let room = data["room"] {
                self.room = room
                print(room)
                self.ref.child("/gameRooms/\(self.room)/players").observe(DataEventType.value, with: { (snapshot) in
                    let roomDetails = snapshot.value as? [String : Bool] ?? [:]
                    DispatchQueue.main.async {
                        self.waitingRoomEventHandler(roomDetails)
                    }
                    
                })
            }
        }
    }
    
    func waitingRoomEventHandler(_ details: [String: Bool]) {
        for (id, val) in details {
            print("\(id): \(val)")
            if (id != self.uid) && (self.onlinePlayerDetails[id] == nil) {
                onlinePlayerDetails[id] = [:]
                self.ref.child("/users/\(id)/points").getData {(error,snapshot) in
                    if let points = snapshot.value as? Int {
                        self.onlinePlayerDetails[id]!["points"] = points
                    }
                }
                self.ref.child("/users/\(id)/username").getData {(error,snapshot) in
                    if let username = snapshot.value as? String {
                        self.onlinePlayerDetails[id]!["username"] = username
                    }
                    self.ref.child("/users/\(id)/userface").getData {(error,snapshot) in
                        if let face = snapshot.value as? Int {
                            self.onlinePlayerDetails[id]!["face"] = face
                            if face == -1 {
                                let picRef = self.storage.reference().child("userimages/\(id).jpeg")
                                picRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                                  if error != nil {
                                    print("Error downloading opponent image: \(error!)")
                                  } else {
                                    self.onlinePlayerDetails[id]!["image"] = Image(uiImage: UIImage(data: data!)!)
                                    if self.onlinePlayerDetails.count == 2 {
                                        self.opponentUID1 = id
                                    } else if self.onlinePlayerDetails.count == 3 {
                                        self.opponentUID2 = id
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            
                                        }
                                    }
                                  }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func dealRequest() {
        functions.httpsCallable("dealer").call(["room":self.room]) { (result, error) in
            if error != nil {
                print("Error with dealer: \(error!)")
            }
        }
    }
}

