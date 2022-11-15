//
//  EmojiMemoryGame.swift
//  lessen
//
//  Created by Gast Gebruiker on 10/11/2022.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    static var emoji_vehicle = ["🚔", "🏎️", "🚡", "🚢", "🚲", "🛴", "🏍️", "🛵", "🛺", "🚘", "🚒", "🚓"]
    
    @Published private var model: MemoryGame<String> = createMemoryGame()
   
    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 4) { index in
            emoji_vehicle[index]
        }
    }
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    // MARK: - Intents(s)
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
}
