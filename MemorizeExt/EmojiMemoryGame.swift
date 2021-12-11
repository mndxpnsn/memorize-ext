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
    var emojis_str: String
    var theme_color: Color
    var id: Int
    
//    fileprivate init(emojis: [String], emojis_str: String, theme_color: Color, id: Int) {
//        self.emojis = emojis
//        self.emojis_str = emojis_str
//        self.theme_color = theme_color
//        self.id = id
//    }
}

var init_set = false

let emojis_theme1 = ["🚂", "🚀", "🚁", "🚜", "🚗", "🚄", "🛵", "🚅"]
let emojis_theme2 = ["🚗", "🚄", "🛵", "🚅", "🚂", "🚀", "🚁", "🚜"]
let emojis_theme3 = ["🏎", "🚍", "🗿", "🕍", "🚗", "🚄", "🛵", "🚅"]
let emojis_theme4 = ["📡", "💿", "⛓", "🧲", "🚗", "🚄", "🛵", "🚅"]
let emojis_theme5 = ["🛠", "⚙️", "🔫", "🗡", "🚗", "🚄", "🛵", "🚅"]
let emojis_theme6 = ["🏅", "🥜", "🥠", "🎂", "🚗", "🚄", "🛵", "🚅"]

let numberOfPairsOfCardsGlb = 8
var theme_colors: Array<Color> = Array<Color>()
var theme: Int = 0
var theme_counter: Int = 0

func set_emoji_themes() {
    add_theme(emojis: emojis_theme1, num_pairs: numberOfPairsOfCardsGlb, color: Color.red)
    add_theme(emojis: emojis_theme2, num_pairs: numberOfPairsOfCardsGlb, color: Color.blue)
    add_theme(emojis: emojis_theme3, num_pairs: numberOfPairsOfCardsGlb, color: Color.green)
    add_theme(emojis: emojis_theme4, num_pairs: numberOfPairsOfCardsGlb, color: Color.orange)
    add_theme(emojis: emojis_theme5, num_pairs: numberOfPairsOfCardsGlb, color: Color.yellow)
    add_theme(emojis: emojis_theme6, num_pairs: numberOfPairsOfCardsGlb - 1, color: Color.brown)
}

var emoji_themes_glb: [Theme] = [Theme]()

func create_card_content (index: Int) -> String {
    return emoji_themes_glb[theme].emojis[index]
}

func createMemoryGame() -> MemoryGame<String> {
    set_emoji_themes()

    return MemoryGame<String>(numberOfPairsOfCards: emoji_themes_glb[theme].emojis.count, createCardContent: create_card_content)
}

func add_theme(emojis: Array<String>, num_pairs: Int, color: Color) {

    var emojis_loc = Theme(emojis: [], emojis_str: "", theme_color: color, id: theme_counter)
    let num_pairs = emojis.count
    
    emojis_loc.id = theme_counter
    
    for index in 0..<num_pairs {
        emojis_loc.emojis.append(emojis[index])
        emojis_loc.emojis_str = emojis_loc.emojis_str + emojis[index]
    }
    
    emoji_themes_glb.append(emojis_loc)
    theme_colors.append(color)
    
    theme_counter = theme_counter + 1
    
}

class EmojiMemoryGame: ObservableObject {
    
    @Published var emoji_themes: [Theme] = [Theme]()
    
    func get_emoji_themes() -> [Theme] {
        return emoji_themes
    }
    
    func set_theme(id: Int) {
        theme = id
    }
    
    func get_actual_theme() -> Theme {
        return emoji_themes[theme]
    }
    
    func get_emojis_of_theme(theme_id: Int) -> [String] {
        return emoji_themes[theme_id].emojis
    }
    
    func get_unique_random_array(size: Int, diff: Int) -> Array<Int> {
        var set = Set<Int>()
        while set.count < size - diff {
            set.insert(Int.random(in: 0..<size))
        }
        let randArray = Array(set)
        
        return randArray
    }
    
    func add_emojis(theme: Int, emojis_str: String) {
        let size_str = emojis_str.count
        emoji_themes[theme].emojis_str += emojis_str
        
        for index in 0..<size_str {
            let index_str = emojis_str.index(emojis_str.startIndex, offsetBy: index)
            emoji_themes[theme].emojis.append(String(emojis_str[index_str]))
        }
    }
    
    init() {
        set_emoji_themes()
        
        emoji_themes = emoji_themes_glb
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
        model.new_game(num_cards: emoji_themes[theme].emojis.count * 2) {
            index in
            return emoji_themes[theme].emojis[index]
        }
    }
    
    func new_game_with_id(id: Int) {
        theme = id
        model.new_game(num_cards: emoji_themes[theme].emojis.count * 2) {
            index in
            return emoji_themes[theme].emojis[index]
        }
    }
    
    func get_theme() -> Int {
        return theme
    }
    
    func get_theme_color() -> Color {
        return theme_colors[theme]
    }
    
    func get_color_of_theme_with(id: Int) -> Color {
        return theme_colors[id]
    }
    
    func get_score() -> Int {
        return model.get_score()
    }
}
