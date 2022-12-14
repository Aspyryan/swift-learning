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
            insertTheme(named: "Vehicles", emojis: "ððððððððŧðððððððâïļðŦðŽðĐððļðēððķâĩïļðĪðĨðģâīðĒððððððððšð", color: RGBAColor(red: 255, green: 0, blue: 0))
            insertTheme(named: "Sports", emojis: "ðâūïļðâ―ïļðūððĨðâģïļðĨðĨðâ·ðģ", color: RGBAColor(red: 255, green: 255, blue: 0))
            insertTheme(named: "Music", emojis: "ðžðĪðđðŠðĨðšðŠðŠðŧ", color: RGBAColor(red: 255, green: 0, blue: 255))
            insertTheme(named: "Animals", emojis: "ðĨðĢðððððððĶððððððĶðĶðĶðĶðĒððĶðĶðĶðððĶðĶðĶ§ðĶĢððĶðĶðŠðŦðĶðĶðĶŽððĶððĶððĐðĶŪððĶĪðĶĒðĶĐððĶðĶĻðĶĄðĶŦðĶĶðĶĨðŋðĶ", color: RGBAColor(red: 0, green: 100, blue: 255))
            insertTheme(named: "Animal Faces", emojis: "ðĩððððķðąð­ðđð°ðĶðŧðžðŧââïļðĻðŊðĶðŪð·ðļðē", color: RGBAColor(red: 0, green: 255, blue: 50))
            insertTheme(named: "Flora", emojis: "ðēðīðŋâïļððððūðð·ðđðĨðšðļðžðŧ", color: RGBAColor(red: 0, green: 255, blue: 255))
            insertTheme(named: "Weather", emojis: "âïļðĪâïļðĨâïļðĶð§âðĐðĻâïļðĻâïļð§ðĶðâïļðŦðŠ", color: RGBAColor(red: 0, green: 255, blue: 255), numberOfPairs: 4)
            insertTheme(named: "COVID", emojis: "ððĶ ð·ðĪ§ðĪ", color: RGBAColor(red: 0, green: 0, blue: 255), numberOfPairs: 2)
            insertTheme(named: "Faces", emojis: "ððððððððĪĢðĨēâšïļððððððððĨ°ðððððððððĪŠðĪĻð§ðĪððĨļðĪĐðĨģððððððâđïļðĢððŦðĐðĨšðĒð­ðĪð ðĄðĪŊðģðĨķðĨððĪðĪðĪ­ðĪŦðĪĨðŽððŊð§ðĨąðīðĪŪð·ðĪ§ðĪðĪ ", color: RGBAColor(red: 100, green: 100, blue: 100), numberOfPairs: 15)
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
