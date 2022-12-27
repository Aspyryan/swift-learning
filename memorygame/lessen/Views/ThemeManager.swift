//
//  ThemeManager.swift
//  lessen
//
//  Created by Jasper on 27/12/2022.
//

import SwiftUI

struct ThemeManager: View {
    @EnvironmentObject var store: ThemeStore
    
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    NavigationLink(destination: EmojiMemoryGameView(game: EmojiMemoryGame(theme: theme))) {
                        VStack(alignment: .leading) {
                            Text(theme.name)
                                .foregroundColor(Color(rgbaColor: theme.color))
                            HStack {
                                Text(theme.emojis.count == theme.numberOfPairs ? "All of " : String(theme.numberOfPairs) + " pairs from")
                                Text(theme.emojis.count < 6 ? theme.emojis.joined() : theme.emojis[...6].joined())
                            }
                        }
                    }
                    .gesture(editMode == .active ? editGameGesture(for: theme) : nil)
                }
                .onDelete { indexSet in
                    store.themes.remove(atOffsets: indexSet)
                }
                .onMove { indexSet, newOffset in
                    store.themes.move(fromOffsets: indexSet, toOffset: newOffset)
                }
            }
            .navigationTitle("Memorize")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    addThemeButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .sheet(item: $themeToEdit) { theme in
                ThemeEditor(theme: $store.themes[theme])
            }
            .environment(\.editMode, $editMode)
        }
        .onChange(of: store.themes) { newThemes in
            updateThemes(to: newThemes)
        }
    }
    
    private func updateThemes(to newThemes: [Theme]) {
        store.themes.filter { $0.emojis.count >= 2}.forEach { theme in
            if !newThemes.contains(theme) {
                store.themes.remove(theme)
            }
        }
    }
    
    
    @State private var themeToEdit: Theme? = nil
    
    private func editGameGesture(for theme: Theme) -> some Gesture {
        TapGesture(count: 1)
            .onEnded { finalState in
                themeToEdit = theme
            }
    }
    
    private var addThemeButton: some View {
        Button {
            
        } label: {
            Image(systemName: "plus")
        }
    }
}

struct ThemeManager_Previews: PreviewProvider {
    static var previews: some View {
        ThemeManager()
            .environmentObject(ThemeStore(named: "Preview"))
    }
}
