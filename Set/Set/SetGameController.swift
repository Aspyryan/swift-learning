//
//  SetGameController.swift
//  Set
//
//  Created by Gast Gebruiker on 15/11/2022.
//

import SwiftUI

class SetGameController: ObservableObject {
    typealias Card = SetGame.Card
    private static func createSetGame() -> SetGame {
        SetGame()
    }
    @Published private var model: SetGame = createSetGame()
    
    var cards: Array<SetGame.Card> {
        return model.cards
    }
    
    // MARK - intents
    func choose(_ card: Card) {
        model.choose(card)
    }
}
