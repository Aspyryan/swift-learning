//
//  SelectionEffect.swift
//  EmojiArt
//
//  Created by Jasper on 26/12/2022.
//

import SwiftUI

struct SelectionEffect: ViewModifier {
    var emoji: EmojiArtModel.Emoji
    var selectedEmojis: Set<EmojiArtModel.Emoji.ID> = Set()
    
    func body(content: Content) -> some View {
        content
            .overlay(
                selectedEmojis.contains(emoji.id) ? RoundedRectangle(cornerRadius: 0).strokeBorder(lineWidth: 1.2).foregroundColor(.blue) : nil
            )
    }
}

extension View {
    func selectionEffect(for emoji: EmojiArtModel.Emoji, in selectedEmojis: Set<EmojiArtModel.Emoji.ID>) -> some View {
        modifier(SelectionEffect(emoji: emoji, selectedEmojis: selectedEmojis))
    }
}
