//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Jasper on 25/12/2022.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView()
    }
}
