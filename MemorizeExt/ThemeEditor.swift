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
    
    var nameSection: some View {
        Section(header: Text("Name")) {
            Text(String(viewModel.get_actual_theme().id))
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
            viewModel.add_emojis(theme: theme_id, emojis_str: emojis)
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
