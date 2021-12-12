//
//  EmojiMemoryGame.swift
//  Memorize
//  This is the view model
//  Created by mndx on 20/11/2021.
//

//import Foundation
import SwiftUI

struct Theme: Identifiable, Equatable {
    var emojis_str: String
    var theme_color: Color
    var theme_name: String
    var id: Int
}

var init_set = false
var state_read = false
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
    add_theme(emojis: emojis_theme1, num_pairs: numberOfPairsOfCardsGlb, theme_name: "Theme 1")
    add_theme(emojis: emojis_theme2, num_pairs: numberOfPairsOfCardsGlb, theme_name: "Theme 2")
    add_theme(emojis: emojis_theme3, num_pairs: numberOfPairsOfCardsGlb, theme_name: "Theme 3")
    add_theme(emojis: emojis_theme4, num_pairs: numberOfPairsOfCardsGlb, theme_name: "Theme 4")
    add_theme(emojis: emojis_theme5, num_pairs: numberOfPairsOfCardsGlb, theme_name: "Theme 5")
    add_theme(emojis: emojis_theme6, num_pairs: numberOfPairsOfCardsGlb - 1, theme_name: "Theme 6")
}

var emoji_themes_glb: [Theme] = [Theme]()

func create_card_content (index: Int) -> String {
    let index_str = emoji_themes_glb[theme].emojis_str.index(emoji_themes_glb[theme].emojis_str.startIndex, offsetBy: index)
    let index_str_upb = emoji_themes_glb[theme].emojis_str.index(emoji_themes_glb[theme].emojis_str.startIndex, offsetBy: index + 1)
    return String(emoji_themes_glb[theme].emojis_str[index_str..<index_str_upb])
}

func createMemoryGame() -> MemoryGame {
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

    return MemoryGame(numberOfPairsOfCards: emoji_themes_glb[theme].emojis_str.count, createCardContent: create_card_content)
}

func add_theme(emojis: Array<String>, num_pairs: Int, theme_name: String) {

    var emojis_loc = Theme(emojis_str: "", theme_color: Color.cyan, theme_name: theme_name, id: theme_counter)
    let num_pairs = emojis.count
    
    emojis_loc.id = theme_counter
    emojis_loc.theme_name = theme_name
    emojis_loc.theme_color = get_color(theme_id: theme_counter)
    for index in 0..<num_pairs {
        emojis_loc.emojis_str = emojis_loc.emojis_str + emojis[index]
    }
    
    emoji_themes_glb.append(emojis_loc)
    theme_colors.append(emojis_loc.theme_color)
    
    theme_counter = theme_counter + 1
    
}

func read_state() {
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

        let file_name_num_themes = "num_themes"
        let fileURL_num_themes = dir.appendingPathComponent(file_name_num_themes)
        var num_themes = 0
        
        //reading
        do {
            let num = try String(contentsOf: fileURL_num_themes, encoding: .utf8)
            num_themes = Int(num) ?? 0
        }
        catch { print("num themes not read") }
        
        for theme_index in 0..<num_themes {
            
            var theme_elem: Theme
            
            //Read emojis
            let file_name_emojis = "emojis" + String(theme_index)
            let fileURL_emojis = dir.appendingPathComponent(file_name_emojis)
            var emojis_theme = ""
            
            //reading
            do {
                let emojis = try String(contentsOf: fileURL_emojis, encoding: .utf8)
                emojis_theme = emojis
            }
            catch { print("could not read emojis") }
            
            //Read theme name
            let file_name_theme_name = "theme_name" + String(theme_index)
            let fileURL_theme_name = dir.appendingPathComponent(file_name_theme_name)
            var name_theme = ""
            
            //reading
            do {
                let theme_name = try String(contentsOf: fileURL_theme_name, encoding: .utf8)
                name_theme = theme_name
            }
            catch { print("could not read theme name") }
            
            //Read theme id
            let file_name_id = "theme_id" + String(theme_index)
            let fileURL_id = dir.appendingPathComponent(file_name_id)
            var id_theme = 0
            
            //reading
            do {
                let theme_id = try String(contentsOf: fileURL_id, encoding: .utf8)
                id_theme = Int(theme_id) ?? 0
            }
            catch { print("could not read theme name") }
            let color_theme = get_color(theme_id: theme_index)
            theme_elem = Theme(emojis_str: emojis_theme, theme_color: color_theme, theme_name: name_theme, id: id_theme)
            theme_colors.append(color_theme)
            emoji_themes_glb.append(theme_elem)
        }
    }
}

func get_color(theme_id: Int) -> Color {
    let color = theme_id
    switch color {
    case 0: return Color.blue
    case 1: return Color.red
    case 2: return Color.green
    case 3: return Color.yellow
    case 4: return Color.orange
    case 5: return Color.brown
    default: return Color.cyan
    }
}

struct file_struct {
    var emojis: String
    var theme_name: String
    var id: Int
}

let color: Int = 0

class EmojiMemoryGame: ObservableObject {
    
    @Published var emoji_themes: [Theme] = [Theme]()
    
    func get_emoji_themes() -> [Theme] {
        return emoji_themes
    }
    
    func save_state() {
        let num_themes = emoji_themes.count
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            //Save number of themes
            let file_name_num_themes = "num_themes"
            let fileURL_num_themes = dir.appendingPathComponent(file_name_num_themes)
            
            //writing
            do {
                let num_themes = String(emoji_themes.count)
                try num_themes.write(to: fileURL_num_themes, atomically: false, encoding: .utf8)
            }
            catch { print("writing to file failed") }
            
            for theme_index in 0..<num_themes {
                
                //Save emojis
                let file_name_emojis = "emojis" + String(theme_index)
                let fileURL_emojis = dir.appendingPathComponent(file_name_emojis)
                
                //writing
                do {
                    let emojis_str = emoji_themes[theme_index].emojis_str
                    try emojis_str.write(to: fileURL_emojis, atomically: false, encoding: .utf8)
                }
                catch { print("writing to file failed") }
                
                //Save theme name
                let file_name_theme_name = "theme_name" + String(theme_index)
                let fileURL_theme_name = dir.appendingPathComponent(file_name_theme_name)
                
                //writing
                do {
                    let theme_name = emoji_themes[theme_index].theme_name
                    try theme_name.write(to: fileURL_theme_name, atomically: false, encoding: .utf8)
                }
                catch { print("writing to file failed") }
                
                //Save theme id
                let file_name_id = "theme_id" + String(theme_index)
                let fileURL_id = dir.appendingPathComponent(file_name_id)
                
                //writing
                do {
                    let id = String(emoji_themes[theme_index].id)
                    try id.write(to: fileURL_id, atomically: false, encoding: .utf8)
                }
                catch { print("writing to file failed") }
            }
        }
    }
    
    func set_theme(id: Int) {
        theme = id
    }
    
    func get_actual_theme() -> Theme {
        return emoji_themes[theme]
    }
    
    func get_emojis_of_theme(theme_id: Int) -> String {
        return String(emoji_themes[theme].emojis_str)
    }
    
    func remove_theme_with(theme_offset: IndexSet) {
        emoji_themes.remove(atOffsets: theme_offset)
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
        withAnimation {
            emoji_themes[theme].emojis_str = (emojis_str + emoji_themes[theme].emojis_str)
        }
        let num_emoji = emoji_themes[theme].emojis_str.count
        remove_repeating_emoji(num_emoji: num_emoji)
    }
    
    func change_to_name(theme: Int, text: String) {
        emoji_themes[theme].theme_name = text
    }
    
    func remove_emoji(emoji: Character) {
        var emojis_loc = ""
        let num_emoji = emoji_themes[theme].emojis_str.count
        
        for index in 0..<num_emoji {
            let index_ref = emoji_themes[theme].emojis_str.index(emoji_themes[theme].emojis_str.startIndex, offsetBy: index)
            let ref_elem = emoji_themes[theme].emojis_str[index_ref]
            if ref_elem == emoji {
                
            }
            else {
                emojis_loc = emojis_loc + String(ref_elem)
            }
        }
        
        emoji_themes[theme].emojis_str = emojis_loc
    }
    
    func remove_repeating_emoji(num_emoji: Int) {
        var emojis_loc = ""
        
        for i in 0..<num_emoji {
            let index_ref = emoji_themes[theme].emojis_str.index(emoji_themes[theme].emojis_str.startIndex, offsetBy: i)
            var is_not_duplicate = true
            for j in 0..<i {
                let index_curr = emoji_themes[theme].emojis_str.index(emoji_themes[theme].emojis_str.startIndex, offsetBy: j)
                let ref_elem = emoji_themes[theme].emojis_str[index_ref]
                let curr_elem = emoji_themes[theme].emojis_str[index_curr]
                let is_duplicate = ref_elem == curr_elem
                if is_duplicate {
                    is_not_duplicate = false
                }
            }
            if is_not_duplicate {
                emojis_loc = emojis_loc + String(emoji_themes[theme].emojis_str[index_ref])
            }
        }
        
        emoji_themes[theme].emojis_str = emojis_loc
    }
    
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
        
        emoji_themes = emoji_themes_glb
    }
    
    @Published private(set) var model: MemoryGame = createMemoryGame()

    var cards: Array<MemoryGame.Card> {
        return model.cards
    }
    
    // MARK: - Intent(s)
    func choose(_ card: MemoryGame.Card) {
        model.choose(card)
    }
    
    func new_game() {
        model.new_game(num_cards: emoji_themes[theme].emojis_str.count * 2) {
            index in
            
            let index_str = emoji_themes[theme].emojis_str.index(emoji_themes[theme].emojis_str.startIndex, offsetBy: index)
            let index_str_upb = emoji_themes[theme].emojis_str.index(emoji_themes[theme].emojis_str.startIndex, offsetBy: index + 1)
            return String(emoji_themes[theme].emojis_str[index_str..<index_str_upb])
        }
    }
    
    func add_new_theme() {
        let num_themes = emoji_themes.count
        let new_theme = Theme(emojis_str: "", theme_color: Color.cyan, theme_name: "", id: num_themes)
        emoji_themes.append(new_theme)
        theme_colors.append(Color.cyan)
    }
    
    func new_game_with_id(id: Int) {
        theme = id
        model.new_game(num_cards: emoji_themes[theme].emojis_str.count * 2) {
            index in
            let index_str = emoji_themes[theme].emojis_str.index(emoji_themes[theme].emojis_str.startIndex, offsetBy: index)
            let index_str_upb = emoji_themes[theme].emojis_str.index(emoji_themes[theme].emojis_str.startIndex, offsetBy: index + 1)
            return String(emoji_themes[theme].emojis_str[index_str..<index_str_upb])
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
