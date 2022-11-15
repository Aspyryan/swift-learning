//
//  Theme.swift
//  lessen
//
//  Created by Gast Gebruiker on 15/11/2022.
//

import Foundation

struct Theme {
    var name: String
    var emoji: Array<String>
    var numberOfPairsOfCards: Int
    var color: [String]
    
    init(name: String, emoji: Array<String>, color: [String], numberOfPairsOfCards: Int? = nil, randomNumberOfCards: Bool = false) {
        self.name = name
        self.emoji = emoji
        self.color = color
        if let potentialNumberOfPairsOfCards = numberOfPairsOfCards {
            self.numberOfPairsOfCards = potentialNumberOfPairsOfCards > emoji.count ? emoji.count : potentialNumberOfPairsOfCards
        } else if (randomNumberOfCards) {
            self.numberOfPairsOfCards = Int.random(in: 1..<emoji.count+1)
        } else {
            self.numberOfPairsOfCards = emoji.count
        }
    }
}
