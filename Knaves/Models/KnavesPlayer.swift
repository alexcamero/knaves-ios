//
//  KnavesPlayer.swift
//  Knaves
//
//  Created by The Captain on 3/24/21.
//

import Foundation

protocol KnavesPlayer {
    /// Protocol for interacting with the KnavesGame
    
    var name: String { get set }
    var game: KGame? { get set }
    var score: [Int] { get set }
    var face: Int { get set }
    
    func move(_ position: Int)

    func receiveBroadcast(playerPosition: Int, cardPlayed: Card?)
    func receiveResult(finalScores: [Int], winnerIndex: [Int])
    func receiveHandScores(_ handScores: [Int])
    func receivePlayerNames(position: Int, names: [String], faces: [Int])
    func receiveHand(hand: [Card], trumpCard: Card)

}


class RandomPlayer: KnavesPlayer {
    /// Computer player for Knaves that follows the rules, but plays randomly otherwise
    
    var name = randomNames.randomElement()!
    var face = Int.random(in: 1..<numberOfFaces+1)
    var currentSuit = -1
    var hand: [Card] = []
    var trickCount = 0
    var players: [String] = []
    var position: Int = -1
    var game: KGame?
    var score = [0,0,0]

    
    func receiveHand(hand: [Card], trumpCard: Card) {
        self.hand = hand
    }
    
    func move(_ position: Int) {
        if self.position == position {
            var cardToPlay = Card(rank: -1, suit: -1)
            if currentSuit != -1 {
                for i in 0..<hand.count {
                    if hand[i].suit == currentSuit {
                        cardToPlay = hand[i]
                        hand.remove(at: i)
                        break
                    }
                }
            }
            if cardToPlay == Card(rank: -1, suit: -1) {
                cardToPlay = hand[0]
                hand.remove(at: 0)
            }
            game!.move(card: cardToPlay)
        }
    }
    
    func receiveBroadcast(playerPosition: Int, cardPlayed: Card?) {
        if let card = cardPlayed {
            if trickCount == 0 {
                currentSuit = card.suit
            } else if trickCount == 2 {
                currentSuit = -1
            }
            trickCount = (trickCount + 1) % 3
        }
    }
    
    func receiveResult(finalScores: [Int], winnerIndex: [Int]) {
        
    }
    
    func receiveHandScores(_ handScores: [Int]) {
        
    }
    
    func receivePlayerNames(position: Int, names: [String], faces: [Int]) {
        self.position = position
        
    }
}


let randomNames = ["Kirsten", "Benito", "Jayjay", "Jarold", "Neithan", "Nakeia", "Yuliya", "Yer", "Sukhman", "Almarosa", "Rivansh", "Derly", "Chrishon", "Juvens", "Cord", "Iwalani", "Manahil", "Jarvis", "Stormie", "Farzana", "Zailynn", "Sirus", "Karan", "Leeyah", "Shameen", "Mirian", "Arnetra", "Piers", "Miamor", "Riddhi", "Bodi", "Carole", "Haddie", "Aisatou", "Pryce", "Lillyonna", "Kharson", "Taraoluwa", "Syretta", "Andrei", "Shanaya", "Saleemah", "Reco", "Aviv", "Kowan", "Dorotha", "Ryli", "Rawn", "Gaylene", "Zafar", "Troylynn", "Elbin", "Jatana", "Camden", "Coleen", "Nilka", "Raven", "Matias", "Lauralee", "Benny", "Elyse", "Samarah", "Tomika", "Tayton", "Shaterica", "Jerrold", "Marfa", "Andrea", "Austreberto", "Jleigh", "Lacie", "Romeo", "Shloime", "Davell", "Kattleya", "Avner", "Eliora", "Stevie", "Herminio", "Mikeisha", "Beila", "Mashawn", "Anjelique", "Ronica", "Saide", "Tess", "Jina", "Jerry", "Carrigan", "Itamar", "Anastassia", "Yaron", "Jeannene", "Mikhael", "Taysha", "Rolly", "Kharter", "Manas", "Zach", "Amadou", "Quirino", "Colston", "Shatavia", "Labrittany", "Michal", "Ismerai", "Jakeria", "Caydan", "Javonte", "Akhil", "Daily", "Mairani", "Nabeel", "Klynn", "Kaile", "Klay", "Lebaron", "Jaslene", "Ahkeem", "Catalino", "Nyshawn", "Tyechia", "Loann", "Mardell", "Shamiyah", "Avrohom", "Aliyanna", "Cheskel", "Jisel", "Djibril", "Judee", "Katharyn", "Willette", "Vishal", "Becky", "Mazikeen", "Sir", "Allia", "Zoriah", "Lianne", "Jerauld", "Analayah", "Kabir", "Danny", "Taiki", "Yemaya", "Thurmon", "Kayan", "Miroslava", "Graceann", "Kennidy", "Kalisha", "Mackenson", "Fynn", "Larinda", "Jakaya", "Haliegh", "Erskine", "Adelayda", "Alydia", "Ezmeralda", "Tonjua", "Kujtim", "Georgann", "Jaxxon", "Enola", "Rilee", "Jaquelyne", "Renaldo", "Raheen", "Tylie", "Juanisha", "Akyra", "Vanna", "Latiqua", "Cornell", "Drevon", "Lidia", "Rontavious", "Raychel", "Michelangelo", "Zayed", "Sherra", "Yeila", "Eneida", "Keanna", "Basilia", "Kotaro", "Kishawn", "Laylanie", "Maleek", "Maxime", "Lenna", "Sammye", "Lollie", "Fredrica", "Codey", "Kenji", "Ascher", "Shakima", "Aiyden", "Rudolf", "Basma", "Zhuri", "Shawon", "Tria", "Rees", "Teodora", "Delene", "Reeves", "Meika", "Annalise", "Dmitri", "Retal", "Cortnee", "Domenica", "Dellanira", "Sanjuana", "Elenore", "Luann", "Trinitee", "Shayda", "Sherrice", "Stormy", "Rashidah", "Harmony", "Raeann", "Xylia", "Meryl", "Ramses", "Townsend", "Ciarra", "Naomi", "Emelia", "Jaxton", "Trevaughn", "Charleen", "Lindsi", "Dannielle", "Izzah", "Deepika", "Malana", "Frayda", "Sheneka", "Murline", "Twalla", "Diamon", "Taylor", "Noam", "Genises", "Tannaz", "Mychelle", "Aditri", "Evan", "Riggins", "Kodah", "Alexande", "Zanyia", "Charm", "Shawntez", "Kambra", "Beauty", "Hiya", "Deloy", "Anastasios", "Trude", "Wallace", "Shalik", "Shanay", "Adali", "Nyanna", "Bette", "Isamara", "Mallary", "Trayvion", "Ameri", "Amyrie", "Ashot", "Shaneika", "Angeleena", "Alaynah", "Tyasia", "Isai", "Eyvonne", "Magnolia", "Brehon", "Nashay", "Libertad", "Osnas", "Odie", "Khalen", "Markese", "Matisyahu", "Keilly", "Chad", "Hanniel", "Victoriana", "Tenika", "Hillary", "Cletis", "Shann", "Idrissa", "Jahrel", "Latrelle", "Ozie", "Talena", "Danner", "Merlin", "Vernessa", "Tammara", "Serge", "Auria", "Keyera", "Lekendrick", "Elysha", "Kyri", "Bo", "Romee", "Anyelin", "Jenipher", "Dalana", "Yo", "Altamease", "Ayiana", "Suhaill", "Alyza", "Hadden", "Jayla", "Kentley", "Tahitoa", "Jailyne", "Derk", "Mireille", "Sidney", "Nahal", "Der", "Merlene", "Arhaan", "Eudora", "Crista", "Alayssa", "Mylani", "Fatimata", "Eboni", "Somer", "Aadyn", "Denim", "Quinesha", "Kaimalu", "Velinda", "Donatella", "Lucila", "Marisha", "Neveen", "Delany", "Jahziah", "Nathalya", "Dayro", "Leeam", "Kenlee", "Cherika", "Theda", "Calamity", "Lilli", "Shataya", "Riya", "Willie", "Cordel", "Sumeya", "Vivika", "Mayola", "Denorris", "Micah", "Estanislado", "Nance", "Brendyn", "Itxel", "Muscab", "Sydell", "Jaelee", "Kaia", "Yoali", "Deshanti", "Dany", "Bridgett", "Maurine", "Julyanna", "Izelle", "Atara", "Milam", "Karma", "Tiffini", "Geraldene", "Holton", "Lilac", "Rye", "Dallis", "Arielle", "Roxi", "Sukhpreet", "Alexander", "Moana", "Janiqua", "Michaela", "Sneyder", "Alyric", "Jase", "Montrel", "Tamir", "Rosmery", "Domingos", "Rashelle", "Meichele", "Pamila", "Krishiv", "Virgina", "Kolter", "Frederick", "Augustina", "Devion", "Keli", "Elson", "Janaia", "Kha", "Jun", "Eniyah", "Denver", "Yanin", "Hannahgrace", "Ralphie", "Sofiah", "Dung", "Kiele", "Dina", "Eldrick", "Yanil", "Etty", "Aizen", "Cove", "Champagne", "Cutberto", "Charday", "Yarelin", "Hillman", "Jaxsen", "Susanne", "Miabella", "Kynzley", "Ismael", "Silvano", "Akram", "Ebbie", "Camilia", "Lacheryl", "Kaesyn", "Miski", "Milton", "Linnea", "Tzirel", "Ania", "Mcgwire", "Ric", "Jadyn", "Shareena", "Landis", "Juany", "Ariday", "Kyndall", "Deeann", "Stormee", "Kelci", "Antonela", "Cyanne", "Joli", "Annay", "Yuniel", "Kinzlee", "Jaliah", "Perri", "Maliki", "Krisann", "Tyshae", "Arika", "Krishna", "Jeriyah", "Aaryan", "Rebekah", "Zeena", "Silvia", "Eriq", "Phong", "Meelah", "Uniqua", "Eloisa", "Valyncia", "Demontray"]

