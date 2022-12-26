//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Jasper on 25/12/2022.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    var document = EmojiArtDocument()
    let paletteStore = PaletteStore(named: "Default")
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: document)
        }
    }
}
