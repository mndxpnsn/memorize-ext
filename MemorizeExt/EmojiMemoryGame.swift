//
//  EmojiMemoryGame.swift
//  Memorize
//  This is the view model
//  Created by mndx on 20/11/2021.
//

//import Foundation
import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    @Published private(set) var model: MemoryGame = createMemoryGame()
    
    init() {
        if state_read == false {
            read_state()
            state_read = true
        }
        if emoji_themes_glb.isEmpty {
            if init_set == false {
                set_emoji_themes()
                init_set = true
            }
        }
        
        save_state()
    }
    
    func get_emoji_themes() -> [Theme] {
        return model.emoji_themes
    }
    
    func save_state() {
        model.save_state()
    }

    func get_emojis_of_theme(theme_id: Int) -> String {
        return model.get_emojis_of_theme(theme_id: theme_id)
    }
    
    func remove_theme_with(theme_offset: IndexSet) {
        withAnimation {
            model.remove_theme_with(theme_offset: theme_offset)
        }
    }
    
    func move_theme_to(fromOffsets: IndexSet, toOffset: Int) {
        model.move_theme_to(fromOffsets: fromOffsets, toOffset: toOffset)
    }
    
    func add_emojis(theme: Int, emojis_str: String) {
        withAnimation {
            model.add_emojis(theme_id: theme, emojis_str: emojis_str)
        }
    }
    
    func change_to_name(theme_id: Int, text: String) {
        model.change_to_name(theme_id: theme_id, text: text)
    }
    
    func get_theme_name_with(theme_name: String) -> String {
        return model.get_theme_name_with(theme_name: theme_name)
    }
    
    func get_color_of_theme_with_name(theme_name: String) -> Color {
        let color_id_loc = model.get_color_of_theme_with_name(theme_name: theme_name)
        return get_color(theme_id: color_id_loc)
    }
    
    func remove_emoji(emoji: Character) {
        model.remove_emoji(emoji: emoji)
    }
    
    // MARK: - Intent(s)
    func choose(theme_name: String, _ card: Card) {
        model.choose(theme_name: theme_name, card)
    }
    
    func get_cards_with_name(theme_name: String) -> [Card] {
        return model.get_cards_with_name(theme_name: theme_name)
    }
    
    func set_new_game_with_name(theme_name: String) {
        model.new_game_with_name(theme_name: theme_name)
    }
    
    func add_new_theme() {
        model.add_new_theme()
    }
    
    func new_game_with_name(theme_name: String) {
        model.new_game_with_name(theme_name: theme_name)
    }
    
    func get_theme() -> Int {
        return model.get_theme()
    }
    
    func set_theme_with_name(theme_name: String) {
        model.set_theme_with_name(theme_name: theme_name)
    }
    
    func get_score() -> Int {
        return model.get_score()
    }
}
