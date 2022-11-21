//
//  SetGame.swift
//  Set
//
//  Created by Gast Gebruiker on 15/11/2022.
//

import Foundation

struct SetGame {
    private var deck: [Card] = []
    private(set) var cards: [Card] = []
    private var previousCorrect: Bool = false
    public var emptyDeck: Bool { deck.count == 0 }
    
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
                for filling in SetFilling.allCases {
                    for shapeAmount in 1..<4 {
                        deck.append(Card(shape: shape, shapeAmount: shapeAmount, color: color, filling: filling, id: index))
                        index += 1
                    }
                }
            }
        }
        deck.shuffle()
        draw(cards: 12)
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id}),
           cards[chosenIndex].isCorrectelyMatched == nil
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
                    previousCorrect = true
                } else {
                    // Bad match!
                    indexesOfSelectedCards.forEach({ cards[$0].isCorrectelyMatched = false })
                    previousCorrect = false
                }
            } else if indexesOfSelectedCards.count == 4 {
                indexesOfSelectedCards.forEach({
                    if let matched = cards[$0].isCorrectelyMatched, matched == false {
                        cards[$0].isCorrectelyMatched = nil
                    }
                })
                indexesOfSelectedCards = [chosenIndex]
                if previousCorrect {
                    draw(cards: 3)
                }
            }
        }
    }
    
    mutating func drawCards() {
        if previousCorrect {
            previousCorrect = false
            indexesOfSelectedCards = []            
        }
        draw(cards: 3)
    }
    
    mutating private func draw(cards amount: Int) {
        let max = deck.count >= amount ? amount : deck.count
        for _ in 0..<max {
            cards.append(deck.removeFirst())
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

public enum SetShape: CaseIterable {
    case oval
    case tilda
    case diamond
}

public enum SetColors: CaseIterable {
    case green
    case blue
    case red
}

public enum SetFilling: CaseIterable {
    case empty
    case striped
    case filled
}

extension Set {
    func hasOneOr(max: Int) -> Bool {
        self.count == 1 || self.count == max
    }
}
