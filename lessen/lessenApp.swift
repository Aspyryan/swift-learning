//
//  lessenApp.swift
//  lessen
//
//  Created by Gast Gebruiker on 08/11/2022.
//

import SwiftUI

@main
struct lessenApp: App {
    private let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
