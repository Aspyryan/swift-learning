//
//  EmojiArtModel.swift
//  EmojiArt
//
//  Created by Jasper on 25/12/2022.
//

import Foundation

struct EmojiArtModel {
    var background = Background.blank
    var emojis = [Emoji]()
    
    struct Emoji: Hashable, Identifiable {
        var text: String
        var x: Int // offset from center
        var y: Int // offset from center
        var size: Int
        var id: UUID
        
        fileprivate init(text: String, x: Int, y: Int, size: Int, id: UUID) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }
    
    init() {
        
    }
    
    mutating func addEmoji(_ text: String, at location: (x: Int, y: Int), size: Int) {
        emojis.append(Emoji(text: text, x: location.x, y: location.y, size: size, id: UUID()))
    }
    
}
