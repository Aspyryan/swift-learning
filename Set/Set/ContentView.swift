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
        VStack {
            HStack {
                Text("Set").font(.title)
                Spacer()
                Button {
                    game.newGame()
                } label: {
                    Text("New game")
                }
            }
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
            HStack {
                deck
                discardPile
                
                if game.showDraw {
                    Button {
                        game.drawCards()
                    } label: {
                        Text("Draw 3 cards")
                    }
                }
            }
        }
    }
    
    var deck: some View {
        VStack(alignment: .leading) {
            Text("deck")
            Button {
                game.drawCards()
            } label: {Text("draw")}
            .cardify(isSelected: false, isCorrectelyMatched: false)
            .aspectRatio(2/3, contentMode: .fit)
        }
    }
    
    var discardPile: some View {
        VStack(alignment: .leading) {
            Text("discard pile")
            ZStack {
                ForEach(game.discardPile) { card in
                    CardView(card: card)
                        .padding(4)
                }
            }
            .cardify(isSelected: false, isCorrectelyMatched: false)
            .aspectRatio(2/3, contentMode: .fit)
        }
    }
}

struct CardView: View {
    let card: SetGameController.Card
    
    var body: some View {
        ZStack {
            VStack {
                GeometryReader { geometry in
                    VStack {
                        Spacer(minLength: 0)
                        ForEach(0..<card.shapeAmount, id: \.self) { index in
                            switch(card.shape) {
                            case .diamond: diamond
                            case .oval: oval(size: geometry.size)
                            case .tilda: tilda(size: geometry.size)
                            }
                        }
                        Spacer(minLength: 0)
                    }.frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            .padding(.all)
        }
        .foregroundColor(GetColor())
        .cardify(isSelected: card.isSelected, isCorrectelyMatched: card.isCorrectelyMatched)
    }
    
    var diamond: some View {
        ZStack {
            Diamond(filling: SetFilling.empty).opacity(GetOpacity())
            Diamond(filling: SetFilling.empty).stroke(GetColor(), lineWidth: 3)
        }
    }
    
    func tilda(size: CGSize) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20).stroke(GetColor(), lineWidth: 3).frame(width: size.width, height: size.height / 3)
            RoundedRectangle(cornerRadius: 20).fill(GetColor()).opacity(GetOpacity()).frame(width: size.width, height: size.height / 3)
        }
    }
    
    func oval(size: CGSize) -> some View {
        ZStack {
            Rectangle().stroke(GetColor(), lineWidth: 3).frame(width: size.width, height: size.height / 3)
            Rectangle().fill(GetColor()).opacity(GetOpacity()).frame(width: size.width, height: size.height / 3)
        }
        
    }
    
    func GetOpacity() -> Double {
        switch(card.filling) {
        case .empty: return 0
        case .filled: return 1
        case .striped: return 0.3
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
