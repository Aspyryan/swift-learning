//
//  EmojiMemoryGame.swift
//  lessen
//
//  Created by Gast Gebruiker on 10/11/2022.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    private static let emoji_vehicle = ["🚔", "🏎️", "🚡", "🚢", "🚲", "🛴", "🏍️", "🛵", "🛺", "🚘", "🚒", "🚓"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 4) { index in
            emoji_vehicle[index]
        }
    }
    
    @Published private var model = createMemoryGame()
       
    var cards: Array<Card> {
        return model.cards
    }
    
    // MARK: - Intents(s)
    func choose(_ card: Card) {
        model.choose(card)
    }
}
