

import Foundation
import MultipeerConnectivity

struct HostedGame: Identifiable, Equatable {
    var id = UUID()
    var mcid: MCPeerID
    var name: String
}

struct GameCommunicationPacket: Codable {
    var type: String
    var position: Int = -1
    var playerNames: [String] = []
    var hand: [Card] = []
    var card: Card?
    var scores: [Int] = []
    var winner: [Int] = []
}

class MultiplayerManager: MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, ObservableObject, MCSessionDelegate, KGame {
    
    
    func move(card: Card) {
        if let host = player.hostID {
            do {
                try mcSession.send(JSONEncoder().encode(GameCommunicationPacket(type: "cardPlayed", card: card)), toPeers: [host], with: .reliable)
            } catch {
                print("Failed to send card played.")
            }
            
        }
    }
    
    func newHand() {

    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async{
            self.player.connectedPlayers = session.connectedPeers
            if let host = self.player.hostID {
                if (peerID == host) && (state == .notConnected) && !self.inGame {
                    self.player.hostID = nil
                    self.player.state = .localMain
                } else if (state == .notConnected) && self.inGame {
                    self.inGame = false
                    self.player.hostID = nil
                    self.mcSession.disconnect()
                    self.mcBrowser.startBrowsingForPeers()
                    self.player.state = .localMain
                }
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            let communication = try JSONDecoder().decode(GameCommunicationPacket.self, from: data)
            DispatchQueue.main.async{
                if communication.type == "playerNames" {
                    self.player.receivePlayerNames(position: communication.position, names: communication.playerNames, faces: communication.scores)
                } else if communication.type == "hand" {
                    self.player.receiveHand(hand: communication.hand, trumpCard: communication.card!)
                } else if communication.type == "moveRequested" {
                    self.player.move(communication.position)
                } else if communication.type == "moveReceived" {
                    self.player.receiveBroadcast(playerPosition: communication.position, cardPlayed: communication.card)
                } else if communication.type == "finalScores" {
                    self.player.receiveResult(finalScores: communication.scores, winnerIndex: communication.winner)
                } else if communication.type == "handScores" {
                    self.player.receiveHandScores(communication.scores)
                } else if communication.type == "cardPlayed" {
                    self.player.game!.move(card: communication.card!)
                } else if communication.type == "gameStart" {
                    self.player.game = self
                    self.mcBrowser.stopBrowsingForPeers()
                    self.inGame = true
                } else {
                    print("Did not understand the following communication type: \(communication.type)")
                }
            }
        } catch {
            print("Had trouble decoding a game communication packet!")
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        if mcSession.connectedPeers.count < 2 {
            do {
                if let data = context {
                    faceLookup[peerID] = try JSONDecoder().decode(Int.self, from: data)
                }
            } catch {
                print("Could not decode a face.")
            }
            invitationHandler(true, mcSession)
        }
        
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if let gameInfo = info {
            DispatchQueue.main.async{
                self.player.localGames.append(HostedGame(mcid: peerID, name: gameInfo["gameName"]!))
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        DispatchQueue.main.async{
            self.player.localGames = self.player.localGames.filter{ $0.mcid != peerID}
        }
    }
    
    func isEqual(_ object: Any?) -> Bool {
        false
    }
    
    var hash: Int = 0
    
    var superclass: AnyClass?
    
    func `self`() -> Self {
        self
    }
    
    func perform(_ aSelector: Selector!) -> Unmanaged<AnyObject>! {
        Unmanaged.passRetained(UIColor.white.cgColor)
    }
    
    func perform(_ aSelector: Selector!, with object: Any!) -> Unmanaged<AnyObject>! {
        Unmanaged.passRetained(UIColor.white.cgColor)
    }
    
    func perform(_ aSelector: Selector!, with object1: Any!, with object2: Any!) -> Unmanaged<AnyObject>! {
        Unmanaged.passRetained(UIColor.white.cgColor)
    }
    
    func isProxy() -> Bool {
        false
    }
    
    func isKind(of aClass: AnyClass) -> Bool {
        false
    }
    
    func isMember(of aClass: AnyClass) -> Bool {
        false
    }
    
    func conforms(to aProtocol: Protocol) -> Bool {
        false
    }
    
    func responds(to aSelector: Selector!) -> Bool {
        false
    }
    
    var description: String = ""
    
    let service = "knaves-game"
    var mcPeerID: MCPeerID
    var mcAdvertiser: MCNearbyServiceAdvertiser
    var mcBrowser: MCNearbyServiceBrowser
    var mcSession: MCSession
    var player: HumanPlayer
    var players: [KnavesPlayer] = []
    var inGame = false
    var faceLookup: [MCPeerID:Int] = [MCPeerID(displayName: UIDevice.current.name):0]

    
    init(player: HumanPlayer, name: String = UIDevice.current.name) {
        self.player = player
        mcPeerID = MCPeerID(displayName: name)
        faceLookup[mcPeerID] = player.face
        mcSession = MCSession(peer: mcPeerID)
        mcBrowser = MCNearbyServiceBrowser(peer: mcPeerID, serviceType: service)
        mcAdvertiser = MCNearbyServiceAdvertiser(peer: mcPeerID, discoveryInfo: ["gameName": name + "'s Game"], serviceType: service)
        mcSession.delegate = self
        mcBrowser.delegate = self
        mcAdvertiser.delegate = self
        mcBrowser.startBrowsingForPeers()
    }
    
    func startHostingGame() {
        DispatchQueue.main.async{
            self.player.state = .localHost
            self.mcAdvertiser.startAdvertisingPeer()
        }
    }
    
    func stopHostingGame() {
        mcAdvertiser.stopAdvertisingPeer()
        mcSession.disconnect()
        DispatchQueue.main.async{
            self.player.state = .localMain
        }
    }
    
    func joinGame(_ id: MCPeerID) {
        do {
            try mcBrowser.invitePeer(id, to: mcSession, withContext: JSONEncoder().encode(player.face), timeout: 5)
            DispatchQueue.main.async{
                self.player.hostID = id
                self.player.state = .localJoined
            }
        } catch {
                print("Trouble joining game")
            }
        
    }

    
    func leaveGame() {
        mcSession.disconnect()
        DispatchQueue.main.async{
            self.player.hostID = nil
            self.player.state = .localMain
        }
    }
    
    func startGame() {
        do {
            try mcSession.send(JSONEncoder().encode(GameCommunicationPacket(type: "gameStart")), toPeers: player.connectedPlayers, with: .reliable)
        } catch {
            print("Couldn't start game.")
        }
        if self.mcSession.connectedPeers.count == 0 {
            players = [player,RandomPlayer(),RandomPlayer()]
        } else if self.mcSession.connectedPeers.count == 1 {
            players = [player,RemotePlayer(id: self.mcSession.connectedPeers[0], gameManager: self, face: faceLookup[self.mcSession.connectedPeers[0]]!), RandomPlayer()]
        } else {
            players = [player,RemotePlayer(id: self.mcSession.connectedPeers[0], gameManager: self, face: faceLookup[self.mcSession.connectedPeers[0]]!), RemotePlayer(id: self.mcSession.connectedPeers[1], gameManager: self, face: faceLookup[self.mcSession.connectedPeers[1]]!)]
        }
        mcBrowser.stopBrowsingForPeers()
        mcAdvertiser.stopAdvertisingPeer()
        inGame = true
        player.game = KnavesGame(knavesPlayers: players)
        players = player.game!.players
        player.game!.newHand()
    }

}

class RemotePlayer: KnavesPlayer {
    var face: Int
    var name: String
    var game: KGame?
    var players: [String] = []
    var hand: [Card] = []
    var trumpCard: Card = Card(rank: -1, suit: -1)
    var score: [Int] = [0,0,0]
    var id: MCPeerID
    var localGameManager: MultiplayerManager
    
    init(id mcid: MCPeerID, gameManager: MultiplayerManager, face: Int) {
        self.face = face
        self.name = mcid.displayName
        self.id = mcid
        self.localGameManager = gameManager
    }
    
    func move(_ position: Int) {
        do {
            try localGameManager.mcSession.send(JSONEncoder().encode(GameCommunicationPacket(type: "moveRequested", position: position)), toPeers: [id], with: .reliable)
        } catch {
            print("Failed to send move request to \(self.name)")
        }
    }
    
    func receiveBroadcast(playerPosition: Int, cardPlayed: Card?) {
        do {
            try localGameManager.mcSession.send(JSONEncoder().encode(GameCommunicationPacket(type: "moveReceived", position: playerPosition, card: cardPlayed)), toPeers: [id], with: .reliable)
        } catch {
            print("Failed to send move to \(self.name)")
        }
    }
    
    func receiveResult(finalScores: [Int], winnerIndex: [Int]) {
        do {
            try localGameManager.mcSession.send(JSONEncoder().encode(GameCommunicationPacket(type: "finalScores", scores: finalScores, winner: winnerIndex)), toPeers: [id], with: .reliable)
        } catch {
            print("Failed to send final scores to \(self.name)")
        }
    }
    
    func receiveHandScores(_ handScores: [Int]) {
        do {
            try localGameManager.mcSession.send(JSONEncoder().encode(GameCommunicationPacket(type: "handScores", scores: handScores)), toPeers: [id], with: .reliable)
        } catch {
            print("Failed to send hand scores to \(self.name)")
        }
    }
    
    func receivePlayerNames(position: Int, names: [String], faces: [Int]) {
        do {
            try localGameManager.mcSession.send(JSONEncoder().encode(GameCommunicationPacket(type: "playerNames", position: position, playerNames: names, scores: faces)), toPeers: [id], with: .reliable)
        } catch {
            print("Failed to send player names to \(self.name)")
        }
    }
    
    func receiveHand(hand: [Card], trumpCard: Card) {
        do {
            try localGameManager.mcSession.send(JSONEncoder().encode(GameCommunicationPacket(type: "hand", hand: hand, card: trumpCard)), toPeers: [id], with: .reliable)
        } catch {
            print("Failed to send hand to \(self.name)")
        }
    }
}


