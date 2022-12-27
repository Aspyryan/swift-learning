//
//  ThemeEditor.swift
//  lessen
//
//  Created by Jasper on 27/12/2022.
//

import SwiftUI

struct ThemeEditor: View {
    @Binding var theme: Theme
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                nameSection
                emojisSection
                addEmojisSection
                cardCountSection
                colorSection
            }
            .navigationTitle(theme.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { cancelButton }
                ToolbarItem { doneButton }
            }
        }
    }
    
    private var doneButton: some View {
        Button("Done") {
            if presentationMode.wrappedValue.isPresented {
                theme.color = RGBAColor(color: themeColorSelection)
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            if presentationMode.wrappedValue.isPresented {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private var nameSection: some View {
        Section("Theme Name") {
            TextField("theme name", text: $theme.name)
        }
    }
    
    @State private var emojisToAdd: String = ""
    
    private var emojisSection: some View {
        Section("Emojis") {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach (theme.emojis, id: \.self) { emoji in
                    Text(emoji)
                        .font(.system(size: 40))
                        .onTapGesture {
                            theme.numberOfPairs -= 1
                            theme.emojis.removeAll(where: { $0 == emoji })
                        }
                }
            }
        }
    }
    
    private var addEmojisSection: some View {
        Section("Emojis") {
            TextField("Emoji", text: $emojisToAdd)
                .onChange(of: emojisToAdd) { emojis in
                    addEmojis(emojis)
                }
        }
    }
    
    private func addEmojis(_ emojis: String) {
        theme.emojis.append(contentsOf: emojis.filter( { $0.isEmoji } ).map( { String($0) } ))
    }

    private var cardCountSection: some View {
        Section("Card Count") {
            Stepper {
                Text("\(theme.numberOfPairs) pairs")
            } onIncrement: {
                if theme.numberOfPairs < theme.emojis.count {
                    theme.numberOfPairs += 1
                }
            } onDecrement: {
                if theme.numberOfPairs > 2 {
                    theme.numberOfPairs -= 1
                }
            }
        }
    }
    
    @State private var themeColorSelection: Color = .red {
        didSet {
            print("did indeed set")
            theme.color = RGBAColor(color: oldValue)
        }
    }
    
    private var colorSection: some View {
        Section("Color") {
            ColorPicker("Theme Color", selection: $themeColorSelection)
        }
    }
}

//struct ThemeEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        ThemeEditor(editingIndex: 0)
//            .environmentObject(ThemeStore(named: "Preview"))
//    }
//}
