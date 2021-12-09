//
//  EmojiMemoryGame.swift
//  Memorize
//  This is the view model
//  Created by mndx on 20/11/2021.
//

//import Foundation
import SwiftUI

struct Theme: Identifiable, Equatable {
    var emojis: [String]
    var id: Int
}

class EmojiMemoryGame: ObservableObject {
    
    static let numberOfPairsOfCardsGlb = 8
    static var emoji_themes: [Theme] = [Theme]()
    static var theme_colors: Array<Color> = Array<Color>()
    static var theme: Int = 0
    static var init_set = false
    static var theme_counter: Int = 0
    
    static let emojis_theme1 = ["🚂", "🚀", "🚁", "🚜", "🚗", "🚄", "🛵", "🚅"]
    static let emojis_theme2 = ["🚗", "🚄", "🛵", "🚅", "🚂", "🚀", "🚁", "🚜"]
    static let emojis_theme3 = ["🏎", "🚍", "🗿", "🕍", "🚗", "🚄", "🛵", "🚅"]
    static let emojis_theme4 = ["📡", "💿", "⛓", "🧲", "🚗", "🚄", "🛵", "🚅"]
    static let emojis_theme5 = ["🛠", "⚙️", "🔫", "🗡", "🚗", "🚄", "🛵", "🚅"]
    static let emojis_theme6 = ["🏅", "🥜", "🥠", "🎂", "🚗", "🚄", "🛵", "🚅"]
    
    static func set_emoji_themes() {
        add_theme(emojis: emojis_theme1, num_pairs: numberOfPairsOfCardsGlb, color: Color.red)
        add_theme(emojis: emojis_theme2, num_pairs: numberOfPairsOfCardsGlb, color: Color.blue)
        add_theme(emojis: emojis_theme3, num_pairs: numberOfPairsOfCardsGlb, color: Color.green)
        add_theme(emojis: emojis_theme4, num_pairs: numberOfPairsOfCardsGlb, color: Color.orange)
        add_theme(emojis: emojis_theme5, num_pairs: numberOfPairsOfCardsGlb, color: Color.yellow)
        add_theme(emojis: emojis_theme6, num_pairs: numberOfPairsOfCardsGlb - 1, color: Color.brown)
    }
    
    static func get_emoji_themes() -> [Theme] {
        return emoji_themes
    }
    
    static func set_theme(id: Int) {
        theme = id
    }
    
    static func add_theme(emojis: Array<String>, num_pairs: Int, color: Color) {

        var emojis_loc = Theme(emojis: [], id: theme_counter)
        let num_pairs = emojis.count
        
        emojis_loc.id = theme_counter
        
        for index in 0..<num_pairs {
            emojis_loc.emojis.append(emojis[index])
        }
        
        emoji_themes.append(emojis_loc)
        theme_colors.append(color)
        
        theme_counter = theme_counter + 1
        
    }
    
    static func create_card_content (index: Int) -> String {
        return emoji_themes[theme].emojis[index]
    }
    
    static func createMemoryGame() -> MemoryGame<String> {
        if EmojiMemoryGame.init_set == false {
            set_emoji_themes()
            EmojiMemoryGame.init_set = true
        }
        
        return MemoryGame<String>(numberOfPairsOfCards: emoji_themes[theme].emojis.count, createCardContent: create_card_content)
    }
    
    static func get_unique_random_array(size: Int, diff: Int) -> Array<Int> {
        var set = Set<Int>()
        while set.count < size - diff {
            set.insert(Int.random(in: 0..<size))
        }
        let randArray = Array(set)
        
        return randArray
    }
    
    init() {
        if EmojiMemoryGame.init_set == false {
            EmojiMemoryGame.set_emoji_themes()
            EmojiMemoryGame.init_set = true
        }
    }
    
    @Published private(set) var model: MemoryGame<String> = createMemoryGame()

    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    // MARK: - Intent(s)
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func new_game() {
        let theme_count = EmojiMemoryGame.emoji_themes.count
        EmojiMemoryGame.theme = Int.random(in: 0..<theme_count)
        model.new_game(num_cards: EmojiMemoryGame.emoji_themes[EmojiMemoryGame.theme].emojis.count * 2) {
            index in
            return EmojiMemoryGame.emoji_themes[EmojiMemoryGame.theme].emojis[index]
        }
    }
    
    func new_game_with_id(id: Int) {
        EmojiMemoryGame.theme = id
        model.new_game(num_cards: EmojiMemoryGame.emoji_themes[EmojiMemoryGame.theme].emojis.count * 2) {
            index in
            return EmojiMemoryGame.emoji_themes[EmojiMemoryGame.theme].emojis[index]
        }
    }
    
    func get_theme() -> Int {
        return EmojiMemoryGame.theme
    }
    
    func get_theme_color() -> Color {
        return EmojiMemoryGame.theme_colors[EmojiMemoryGame.theme]
    }
    
    func get_color_of_theme_with(id: Int) -> Color {
        return EmojiMemoryGame.theme_colors[id]
    }
    
    func get_score() -> Int {
        return model.get_score()
    }
}
