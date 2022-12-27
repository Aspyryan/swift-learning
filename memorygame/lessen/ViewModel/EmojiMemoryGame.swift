//
//  EmojiMemoryGame.swift
//  lessen
//
//  Created by Gast Gebruiker on 10/11/2022.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
   
    typealias Card = MemoryGame<String>.Card
    
    @Published private var model: MemoryGame<String>
    private var theme: Theme {
        didSet {
            restart()
        }
    }
    
    @Published var isDealt = false
    
    init(theme: Theme) {
        self.theme = theme
        self.model = EmojiMemoryGame.createMemoryGame(from: theme)
    }
    
    private static func createMemoryGame(from theme: Theme) -> MemoryGame<String> {
        let emojis = theme.emojis.shuffled()
        
        return MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairs) { index in
            emojis[index]
        }
    }
       
    var themeName: String {
        return theme.name
    }
    var cards: Array<Card> {
        return model.cards
    }
    
    // MARK: - Intents(s)
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func restart() {
        isDealt = false
        model = EmojiMemoryGame.createMemoryGame(from: theme)
    }
}
