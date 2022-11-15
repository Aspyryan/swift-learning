//
//  SetGame.swift
//  Set
//
//  Created by Gast Gebruiker on 15/11/2022.
//

import Foundation

struct SetGame {
    private(set) var cards: [Card] = []
    var indexesOfSelectedCards: [Int] {
        get { cards.indices.filter({ cards[$0].isSelected}) }
        set {
            cards.indices.forEach({ cards[$0].isSelected = false })
            newValue.forEach({ cards[$0].isSelected = true })
        }
    }
    
    init() {
        var index = 0
        for shape in SetShape.allCases {
            for color in SetColors.allCases {
                for shapeAmount in 1..<4 {
                    cards.append(Card(shape: shape, shapeAmount: shapeAmount, color: color, filling: SetFilling.empty, id: index))
                    index += 1
                }
            }
        }
        print(cards)
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id}),
           cards[chosenIndex].isCorrectelyMatched != true
        {
            cards[chosenIndex].isSelected.toggle()
            if indexesOfSelectedCards.count == 3 {
                // Look if matches
                var colorSet: Set<SetColors> = Set()
                var shapeSet: Set<SetShape> = Set()
                var amountSet: Set<Int> = Set()
                var fillingSet: Set<SetFilling> = Set()
                
                indexesOfSelectedCards.forEach({cardIndex in
                    colorSet.insert(cards[cardIndex].color)
                    shapeSet.insert(cards[cardIndex].shape)
                    amountSet.insert(cards[cardIndex].shapeAmount)
                    fillingSet.insert(cards[cardIndex].filling)
                })
                
                if (
                    colorSet.hasOneOr(max: 3) &&
                    shapeSet.hasOneOr(max: 3) &&
                    amountSet.hasOneOr(max: 3) &&
                    fillingSet.hasOneOr(max: 3)
                ) {
                    // Correctly matched!
                    indexesOfSelectedCards.forEach({ cards[$0].isCorrectelyMatched = true })
                } else {
                    // Bad match!
                    indexesOfSelectedCards.forEach({ cards[$0].isCorrectelyMatched = false })
                }
            } else if indexesOfSelectedCards.count == 4 {
                indexesOfSelectedCards.forEach({
                    if let matched = cards[$0].isCorrectelyMatched, matched == false {
                        cards[$0].isCorrectelyMatched = nil
                    }
                })
                indexesOfSelectedCards = [chosenIndex]
            }
        }
    }
    
    struct Card: Identifiable {
        var shape: SetShape
        var shapeAmount: Int
        var color: SetColors
        var filling: SetFilling
        var isSelected = false
        var isCorrectelyMatched: Bool? = nil
        var id: Int
    }
}

enum SetShape: CaseIterable {
    case oval
    case tilda
    case diamond
}

enum SetColors: CaseIterable {
    case green
    case blue
    case red
}

enum SetFilling: CaseIterable {
    case empty
    case striped
    case filled
}

extension Set {
    func hasOneOr(max: Int) -> Bool {
        self.count == 1 || self.count == max
    }
}
