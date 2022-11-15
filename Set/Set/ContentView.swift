//
//  ContentView.swift
//  Set
//
//  Created by Gast Gebruiker on 15/11/2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var game: SetGameController
    var body: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            if let potentialMatch = card.isCorrectelyMatched, potentialMatch == true, !card.isSelected {}
            else {
                CardView(card: card)
                    .padding(4)
                    .onTapGesture {
                        game.choose(card)
                    }
            }
        }
        .foregroundColor(.red)
    }
}

struct CardView: View {
    let card: SetGameController.Card
    
    var body: some View {
        GeometryReader { geometry in	
            ZStack {
                let shape = RoundedRectangle(cornerRadius: 20)
                shape.fill(.white)
                if card.isSelected {
                    if let potentialMatch = card.isCorrectelyMatched {
                        if potentialMatch == true {
                            shape.fill(.green).opacity(0.4)
                        } else {
                            shape.fill(.red).opacity(0.4)
                        }
                    }
                    shape.strokeBorder(lineWidth: 3).foregroundColor(.yellow)
                }
                VStack {
                    ForEach(0..<card.shapeAmount, id: \.self) { index in
                        Shape()
                    }
                }
            }
            .foregroundColor(GetColor())
        }
    }
    
    func Shape() -> some View {
        switch(card.shape) {
        case .diamond: return Text("diamond")
        case .oval: return Text("oval")
        case .tilda: return Text("tilda")
        }
    }
    
    func GetColor() -> Color {
        switch(card.color) {
        case .red: return .red
        case .green: return .green
        case .blue: return .blue
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameController()
        return ContentView(game: game)
            .preferredColorScheme(.dark)
    }
}
