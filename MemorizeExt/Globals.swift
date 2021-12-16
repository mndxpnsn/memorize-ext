//
//  Globals.swift
//  MemorizeExt
//
//  Created by Derek Harrison on 15/12/2021.
//

import Foundation
import SwiftUI

//Initialize globals
var init_set = false
var state_read = false
var theme_counter: Int = 0
var max_theme_color_id: Int = 0
var emoji_themes_glb: [Theme] = [Theme]()

struct Card: Identifiable, Codable {
    var isFaceUp: Bool = false
    var isMatched: Bool = false
    var isSeen: Bool = false
    var content: String
    var id: Int
}

struct Theme: Identifiable {
    var emojis_str: String
    var theme_color: Color
    var theme_name: String
    var id: Int
    var theme_color_id: Int
    var theme_cards: [Card]
}

//Add some initial emoji and themes
let emojis_theme1 = ["🚂", "🚀", "🚁", "🚜", "🚗", "🚄", "🛵", "🚅"]
let emojis_theme2 = ["🚗", "🚄", "🛵", "🚅", "🚂", "🚀", "🚁", "🚜"]
let emojis_theme3 = ["🏎", "🚍", "🗿", "🕍", "🚗", "🚄", "🛵", "🚅"]
let emojis_theme4 = ["📡", "💿", "⛓", "🧲", "🚗", "🚄", "🛵", "🚅"]
let emojis_theme5 = ["🛠", "⚙️", "🔫", "🗡", "🚗", "🚄", "🛵", "🚅"]
let emojis_theme6 = ["🏅", "🥜", "🥠", "🎂", "🚗", "🚄", "🛵", "🚅"]

func set_emoji_themes() {
    add_theme(emojis: emojis_theme1, num_pairs: emojis_theme1.count, theme_name: "Theme 1")
    add_theme(emojis: emojis_theme2, num_pairs: emojis_theme2.count, theme_name: "Theme 2")
    add_theme(emojis: emojis_theme3, num_pairs: emojis_theme3.count, theme_name: "Theme 3")
    add_theme(emojis: emojis_theme4, num_pairs: emojis_theme4.count, theme_name: "Theme 4")
    add_theme(emojis: emojis_theme5, num_pairs: emojis_theme5.count, theme_name: "Theme 5")
    add_theme(emojis: emojis_theme6, num_pairs: emojis_theme6.count - 1, theme_name: "Theme 6")
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

    return MemoryGame()
}

func add_theme(emojis: Array<String>, num_pairs: Int, theme_name: String) {

    var emojis_loc = Theme(emojis_str: "", theme_color: Color.cyan, theme_name: theme_name, id: theme_counter, theme_color_id: theme_counter, theme_cards: [Card]())
    let num_pairs = emojis.count
    
    emojis_loc.id = theme_counter
    emojis_loc.theme_name = theme_name
    emojis_loc.theme_color = get_color(theme_id: theme_counter)
    emojis_loc.theme_color_id = theme_counter
    
    var card_array: [Card] = [Card]()
    
    for index in 0..<num_pairs {
        emojis_loc.emojis_str = emojis_loc.emojis_str + emojis[index]
    }
  
    for index in 0..<(num_pairs * 2) {
        let card_content_loc = convert_emojis_str_to_cards(emojis: emojis_loc.emojis_str)
        let card_loc = Card(isFaceUp: false, isMatched: false, isSeen: false, content: card_content_loc[index/2], id: index)
        card_array.append(card_loc)
    }
    
    var card_array_reordered: [Card] = [Card]()
    
    let num_cards_in_arr = num_pairs * 2
    let randArray = get_unique_random_array(size: num_cards_in_arr)
    for index in 0..<num_cards_in_arr {
        let index_loc = randArray[index]
        let card_loc = card_array[index_loc]
        card_array_reordered.append(card_loc)
    }
    
    emojis_loc.theme_cards = card_array_reordered
    max_theme_color_id = theme_counter

    emoji_themes_glb.append(emojis_loc)
    
    theme_counter = theme_counter + 1
    
}

func get_unique_random_array(size: Int) -> Array<Int> {
    var set = Set<Int>()
    while set.count < size {
        set.insert(Int.random(in: 0..<size))
    }
    let randArray = Array(set)
    
    return randArray
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
        
        //Read max color id
        let file_max_color_id = "max_color_id"
        let fileURL_max_color_id = dir.appendingPathComponent(file_max_color_id)
        
        //reading
        do {
            let max_color_id_loc = try String(contentsOf: fileURL_max_color_id, encoding: .utf8)
            max_theme_color_id = Int(max_color_id_loc) ?? 0
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
            
            //Read theme color id
            let file_name_color_id = "theme_color_id" + String(theme_index)
            let fileURL_color_id = dir.appendingPathComponent(file_name_color_id)
            var color_id_theme = 0
            
            //reading
            do {
                let color_id = try String(contentsOf: fileURL_color_id, encoding: .utf8)
                color_id_theme = Int(color_id) ?? 0
            }
            catch { print("could not read theme name") }
            
            var emoji_array: [String]
            
            //Create card array from emojis
            emoji_array = convert_emojis_str_to_cards(emojis: emojis_theme)
            var card_array = [Card]()
            
            let num_cards_in_arr = emoji_array.count * 2
            let randArray = get_unique_random_array(size: num_cards_in_arr)
            for index in 0..<num_cards_in_arr {
                let index_loc = randArray[index]
                let elem_loc = Card(isFaceUp: false, isMatched: false, isSeen: false, content: emoji_array[index_loc/2], id: index)
                card_array.append(elem_loc)
            }
            
            let color_theme = get_color(theme_id: color_id_theme)
            theme_elem = Theme(emojis_str: emojis_theme, theme_color: color_theme, theme_name: name_theme, id: id_theme, theme_color_id: color_id_theme, theme_cards: card_array)
            emoji_themes_glb.append(theme_elem)
        }
    }
}

func convert_emojis_str_to_cards(emojis: String) -> [String] {
    var card_array = [String]()
    let num_emojis = emojis.count
    
    for index_loc in 0..<num_emojis {
        let index_str = emojis.index(emojis.startIndex, offsetBy: index_loc)
        let index_str_upb = emojis.index(emojis.startIndex, offsetBy: index_loc + 1)
        let elem = String(emojis[index_str..<index_str_upb])
        
        card_array.append(elem)
    }
    
    return card_array
}

func get_color(theme_id: Int) -> Color {
    var color = theme_id
    color = color % 10
    switch color {
    case 0: return Color.blue
    case 1: return Color.red
    case 2: return Color.green
    case 3: return Color.yellow
    case 4: return Color.orange
    case 5: return Color.brown
    case 6: return Color.gray
    case 7: return Color.mint
    case 8: return Color.indigo
    case 9: return Color.pink
    case 10: return Color.orange
    default: return Color.cyan
    }
}
