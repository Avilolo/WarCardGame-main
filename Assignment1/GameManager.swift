import Foundation

class GameManager {
    private var deck: [String] = []
    
    init() {
        self.deck = createDeck()
    }
    
    func createDeck() -> [String] {
        let suits = ["hearts", "diamonds", "clubs", "spades"]
        let ranks = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
        var deck = [String]()
        
        for suit in suits {
            for rank in ranks {
                deck.append("\(rank)_of_\(suit)")
            }
        }
        deck.shuffle()
        return deck
    }
    
    func dealCards() -> (player1Card: String, player2Card: String) {
        if deck.count < 2  {
            deck = createDeck()
        }
        
        let player1Card = deck.removeFirst()
        let player2Card = deck.removeFirst()
        
        return (player1Card, player2Card)
    }
    
    func evaluateCards() -> (winner: Int, player1Card: String, player2Card: String) {
            let result = dealCards()
            let winner = compareCards(card1: result.player1Card, card2: result.player2Card)
            return (winner, result.player1Card, result.player2Card)
        }
    
    func compareCards(card1: String, card2: String) -> Int {
        let cardRank = ["2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9, "10": 10, "J": 11, "Q": 12, "K": 13, "A": 14]
        let rank1 = cardRank[String(card1.split(separator: "_")[0])]!
        let rank2 = cardRank[String(card2.split(separator: "_")[0])]!
        
        if rank1 > rank2 {
            return 1
        } else if rank2 > rank1 {
            return 2
        } else {
            return 0
        }
    }
}
