//
//  lessenApp.swift
//  lessen
//
//  Created by Gast Gebruiker on 08/11/2022.
//

import SwiftUI

@main
struct lessenApp: App {
    @StateObject var themeStore: ThemeStore = ThemeStore(named: "App")
    
    var body: some Scene {
        WindowGroup {
            ThemeManager()
                .environmentObject(themeStore)
        }
    }
}
