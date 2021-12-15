//
//  ThemeEditor.swift
//  MemorizeExt
//
//  Created by mndx on 10/12/2021.
//

import SwiftUI

struct ThemeEditor: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        Form {
            nameSection
            addEmojisSection
            removeEmojiSection
        }
        .navigationTitle("Edit ")
    }
    
    @State private var name_to_change = ""
    
    var nameSection: some View {
        Section(header: Text("Name")) {
            TextField("", text: $name_to_change)
                .onChange(of: name_to_change) {text in
                    change_to_name(text: text)
                }
        }
    }
    
    @State private var emojisToAdd = ""
    
    var addEmojisSection: some View {
        Section(header: Text("Add Emojis")) {
            TextField("", text: $emojisToAdd)
                .onChange(of: emojisToAdd) {emojis in
                    addEmojis(emojis)
                }
        }
    }
    
    func addEmojis(_ emojis: String) {
        withAnimation {
            let theme_id = viewModel.get_theme()
            print("theme_id in addemojis \(theme_id)")
            viewModel.add_emojis(theme: theme_id, emojis_str: emojis)
        }
    }

    func change_to_name(text: String) {
        withAnimation {
            let theme_id = viewModel.get_theme()
            viewModel.change_to_name(theme: theme_id, text: text)
        }
    }
    
    var removeEmojiSection: some View {
        Section(header: Text("Remove Emoji")) {
            let theme_id = viewModel.get_theme()
            let emojis = viewModel.get_emojis_of_theme(theme_id: theme_id)
            LazyHGrid(rows: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(Array(emojis), id: \.self) { emoji in
                    Text(String(emoji))
                        .onTapGesture {
                            withAnimation {
                                viewModel.remove_emoji(emoji: (emoji))
                            }
                        }
                }
            }
            .font(.system(size: 40))
        }
    }
    
}
