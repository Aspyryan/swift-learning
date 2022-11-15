//
//  MemoryGame.swift
//  lessen
//
//  Created by Gast Gebruiker on 10/11/2022.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    private(set) var score: Int = 0
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched
        {
            cards[chosenIndex].hasBeenFlippedAt = Date()
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if (cards[chosenIndex].content == cards[potentialMatchIndex].content) {
                    cards[chosenIndex].flippedUpTime += cards[chosenIndex].hasBeenFlippedAt!.distance(to: Date())
                    cards[chosenIndex].hasBeenFlippedAt = nil
                    
                    cards[potentialMatchIndex].flippedUpTime += cards[potentialMatchIndex].hasBeenFlippedAt!.distance(to: Date())
                    cards[potentialMatchIndex].hasBeenFlippedAt = nil
                    
                    score += max(10 - cards[chosenIndex].flippedUpSeconds, 1) +
                             max(10 - cards[potentialMatchIndex].flippedUpSeconds, 1)
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                } else {
                    if cards[chosenIndex].hasBeenFlipped || cards[potentialMatchIndex].hasBeenFlipped {
                        score -= 1
                    }
                }
                indexOfTheOneAndOnlyFaceUpCard = nil
            } else {
                for index in cards.indices {
                    if cards[index].isFaceUp {
                        if let flippedUpDate = cards[index].hasBeenFlippedAt {
                            cards[index].flippedUpTime += flippedUpDate.distance(to: Date())
                        }
                        cards[index].hasBeenFlippedAt = nil
                        cards[index].hasBeenFlipped = true
                        cards[index].isFaceUp = false
                    }
                }
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp = true
        }
        print("\(cards)")
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = Array<Card>();
        for pairIndex in 0..<numberOfPairsOfCards {
            let content: CardContent = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var hasBeenFlipped: Bool = false
        var hasBeenFlippedAt: Date? = nil
        var flippedUpTime: TimeInterval = 0
        var content: CardContent
        var id: Int
        var flippedUpSeconds: Int {
            return Int(self.flippedUpTime)
        }
    }
}
