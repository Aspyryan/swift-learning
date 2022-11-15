//
//  EmojiMemoryGame.swift
//  lessen
//
//  Created by Gast Gebruiker on 10/11/2022.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    init() {
        theme = EmojiMemoryGame.themes.randomElement()!
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    static var themes: Array<Theme> = [
        Theme(name: "Vehicles", emoji: emoji_vehicle, color: ["red", "orange"], numberOfPairsOfCards: 8),
        Theme(name: "Smilies", emoji: emoji_smileys, color: ["green"], randomNumberOfCards: false),
        Theme(name: "Directions", emoji: emoji_directions, color: ["blue"], randomNumberOfCards: true),
    ]
    static var emoji_vehicle = ["🚔", "🏎️", "🚡", "🚢", "🚲", "🛴", "🏍️", "🛵", "🛺", "🚘", "🚒", "🚓"]
    
    static var emoji_smileys = ["😇", "😍", "😭", "😤"]
    static var emoji_directions = ["👈", "👉", "👆","👇"]
    
    @Published private var model: MemoryGame<String>
    
    private var theme: Theme
    var themeColor: Gradient {
        var colorArray: Array<Color> = []
        
        for color: String in theme.color {
            switch color {
            case "red": colorArray.append(.red)
            case "blue": colorArray.append(.blue)
            case "green": colorArray.append(.green)
            case "orange": colorArray.append(.orange)
            default: colorArray.append(.red)
            }
        }

        return Gradient(colors: colorArray)
    }
    
    var themeName: String {
        return theme.name
    }
   
    static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairsOfCards) { index in
            theme.emoji[index]
        }
    }
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    var score: Int {
        return model.score
    }
    
    // MARK: - Intents(s)
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func newGame() {
        theme = EmojiMemoryGame.themes.randomElement()!
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
}
