//
//  SetApp.swift
//  Set
//
//  Created by Gast Gebruiker on 15/11/2022.
//

import SwiftUI

@main
struct SetApp: App {
    var body: some Scene {
        let game = SetGameController()
        WindowGroup {
            ContentView(game: game)
        }
    }
}
