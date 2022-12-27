//
//  ThemeStore.swift
//  lessen
//
//  Created by Jasper on 27/12/2022.
//

import Foundation

struct Theme: Identifiable, Hashable {
    var name: String
    var emojis: [String]
    var color: RGBAColor
    var numberOfPairs: Int
    var id: UUID
}

struct RGBAColor: Codable, Equatable, Hashable {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
    
    init(red: Double, green: Double, blue: Double, alpha: Double = 1) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
}


class ThemeStore: ObservableObject {
    var name: String
    
    @Published var themes = [Theme]()
    
    init(named: String) {
        self.name = named
        
        if themes.isEmpty {
            insertTheme(named: "Vehicles", emojis: "🚙🚗🚘🚕🚖🏎🚚🛻🚛🚐🚓🚔🚑🚒🚀✈️🛫🛬🛩🚁🛸🚲🏍🛶⛵️🚤🛥🛳⛴🚢🚂🚝🚅🚆🚊🚉🚇🛺🚜", color: RGBAColor(red: 255, green: 0, blue: 0))
            insertTheme(named: "Sports", emojis: "🏈⚾️🏀⚽️🎾🏐🥏🏓⛳️🥅🥌🏂⛷🎳", color: RGBAColor(red: 255, green: 255, blue: 0))
            insertTheme(named: "Music", emojis: "🎼🎤🎹🪘🥁🎺🪗🪕🎻", color: RGBAColor(red: 255, green: 0, blue: 255))
            insertTheme(named: "Animals", emojis: "🐥🐣🐂🐄🐎🐖🐏🐑🦙🐐🐓🐁🐀🐒🦆🦅🦉🦇🐢🐍🦎🦖🦕🐅🐆🦓🦍🦧🦣🐘🦛🦏🐪🐫🦒🦘🦬🐃🦙🐐🦌🐕🐩🦮🐈🦤🦢🦩🕊🦝🦨🦡🦫🦦🦥🐿🦔", color: RGBAColor(red: 0, green: 100, blue: 255))
            insertTheme(named: "Animal Faces", emojis: "🐵🙈🙊🙉🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐸🐲", color: RGBAColor(red: 0, green: 255, blue: 50))
            insertTheme(named: "Flora", emojis: "🌲🌴🌿☘️🍀🍁🍄🌾💐🌷🌹🥀🌺🌸🌼🌻", color: RGBAColor(red: 0, green: 255, blue: 255))
            insertTheme(named: "Weather", emojis: "☀️🌤⛅️🌥☁️🌦🌧⛈🌩🌨❄️💨☔️💧💦🌊☂️🌫🌪", color: RGBAColor(red: 0, green: 255, blue: 255), numberOfPairs: 4)
            insertTheme(named: "COVID", emojis: "💉🦠😷🤧🤒", color: RGBAColor(red: 0, green: 0, blue: 255), numberOfPairs: 2)
            insertTheme(named: "Faces", emojis: "😀😃😄😁😆😅😂🤣🥲☺️😊😇🙂🙃😉😌😍🥰😘😗😙😚😋😛😝😜🤪🤨🧐🤓😎🥸🤩🥳😏😞😔😟😕🙁☹️😣😖😫😩🥺😢😭😤😠😡🤯😳🥶😥😓🤗🤔🤭🤫🤥😬🙄😯😧🥱😴🤮😷🤧🤒🤠", color: RGBAColor(red: 100, green: 100, blue: 100), numberOfPairs: 15)
        }
    }
    
    // MARK - Intents
    
    func insertTheme(named name: String, emojis: String, color: RGBAColor, numberOfPairs: Int? = nil) {
        var emojiList = [String]()
        for char in emojis {
            emojiList.append(String(char))
        }
        
        let pairs = numberOfPairs ?? emojiList.count
        
        themes.append(Theme(name: name, emojis: emojiList, color: color, numberOfPairs: pairs, id: UUID()))
    }
}
