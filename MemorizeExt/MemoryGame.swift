//
//  MemoryGame.swift
//  Memorize
//  This is the model
//  Created by mndx on 20/11/2021.
//

import Foundation

struct MemoryGame {
    
    private var theme: Int
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
    private var score: Int
    private(set) var emoji_themes: [Theme] = [Theme]()
    
    init() {
        score = 0
        theme = 0
        
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
        
        save_state()
    }
    
    func create_card_content(theme_id: Int, index: Int) -> String {
        let index_str = emoji_themes[theme_id].emojis_str.index(emoji_themes[theme_id].emojis_str.startIndex, offsetBy: index)
        let index_str_upb = emoji_themes[theme_id].emojis_str.index(emoji_themes[theme_id].emojis_str.startIndex, offsetBy: index + 1)
        return String(emoji_themes[theme_id].emojis_str[index_str..<index_str_upb])
    }
    
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
            
            //Save max color id
            let file_max_color_id = "max_color_id"
            let fileURL_max_color_id = dir.appendingPathComponent(file_max_color_id)
            
            //writing
            do {
                let max_color_id_loc = String(get_max_color_id())
                try max_color_id_loc.write(to: fileURL_max_color_id, atomically: false, encoding: .utf8)
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
                
                
                //Save theme color id
                let file_name_color_id = "theme_color_id" + String(theme_index)
                let fileURL_color_id = dir.appendingPathComponent(file_name_color_id)
                
                //writing
                do {
                    let color_id = String(emoji_themes[theme_index].theme_color_id)
                    try color_id.write(to: fileURL_color_id, atomically: false, encoding: .utf8)
                }
                catch { print("writing to file failed") }
            }
        }
    }
    
    mutating func set_theme(id: Int) {
        theme = id
    }
    
    func get_emojis_of_theme(theme_id: Int) -> String {
        return String(emoji_themes[theme].emojis_str)
    }
    
    mutating func remove_theme_with(theme_offset: IndexSet) {
        emoji_themes.remove(atOffsets: theme_offset)
        let num_themes_loc = emoji_themes.count
        for theme_index in 0..<num_themes_loc {
            emoji_themes[theme_index].id = theme_index
            emoji_themes[theme_index].theme_color = get_color(theme_id: emoji_themes[theme_index].theme_color_id)
        }
        
        save_state()
    }
    
    mutating func move_theme_to(fromOffsets: IndexSet, toOffset: Int) {

        emoji_themes.move(fromOffsets: fromOffsets, toOffset: toOffset)        
        save_state()
    }
    
    func get_cards_with_name(theme_name: String) -> [Card] {
        let num_themes_loc = emoji_themes.count
        var cards_of_theme = [Card]()
        for theme_index_loc in 0..<num_themes_loc {
            if theme_name == emoji_themes[theme_index_loc].theme_name {
                cards_of_theme = emoji_themes[theme_index_loc].theme_cards
            }
        }
        
        return cards_of_theme
    }
    
    func get_unique_random_array(size: Int, diff: Int) -> Array<Int> {
        var set = Set<Int>()
        while set.count < size - diff {
            set.insert(Int.random(in: 0..<size))
        }
        let randArray = Array(set)
        
        return randArray
    }
    
    mutating func add_emojis(theme_id: Int, emojis_str: String) {
        emoji_themes[theme_id].emojis_str = (emojis_str + emoji_themes[theme_id].emojis_str)
        let num_emoji = emoji_themes[theme_id].emojis_str.count
        remove_repeating_emoji(theme_id: theme_id, num_emoji: num_emoji)
        
        let card_array_add = convert_emojis_str_to_cards(emojis: emoji_themes[theme_id].emojis_str)
        let size_card_arr = card_array_add.count * 2
        
        var result: [Card] = [Card]()
        
        
        for card_index in 0..<size_card_arr {
            var card_loc: Card = Card(isFaceUp: false, isMatched: false, isSeen: false, content: card_array_add[card_index/2], id: card_index)
            card_loc.content = card_array_add[card_index/2]
            result.append(card_loc)
        }
        
        let randArray = MemorizeExt.get_unique_random_array(size: size_card_arr)
        
        var result_reordered: [Card] = [Card]()
        
        for index in 0..<size_card_arr {
            let index_loc = randArray[index]
            let card_loc = result[index_loc]
            result_reordered.append(card_loc)
        }
        
        emoji_themes[theme_id].theme_cards = result_reordered
        save_state()
    }
    
    mutating func set_theme_with_name(theme_name: String) {
        let num_themes_loc = emoji_themes.count
        
        //Update current theme
        for theme_index in 0..<num_themes_loc {
            if emoji_themes[theme_index].theme_name == theme_name {
                theme = theme_index
            }
        }
    }
    
    mutating func change_to_name(theme_id: Int, text: String) {
        emoji_themes[theme_id].theme_name = text
        
        save_state()
    }
    
    func get_theme_name_with(theme_name: String) -> String {
        
        let num_themes_loc = emoji_themes.count
        var res_str: String = ""
        for theme_index_loc in 0..<num_themes_loc {
            if emoji_themes[theme_index_loc].theme_name == theme_name {
                res_str = theme_name
            }
        }
        
        return res_str
    }
    
    mutating func remove_emoji(emoji: Character) {
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
        
        let card_str_array = convert_emojis_str_to_cards(emojis: emojis_loc)
        var card_array_loc = [Card]()
        
        let size_arr = card_str_array.count * 2
        
        for card_index in 0..<size_arr {
            let card_loc = Card(isFaceUp: false, isMatched: false, isSeen: false, content: card_str_array[card_index/2], id: card_index)
            card_array_loc.append(card_loc)
        }
        
        var card_array_reordered: [Card] = [Card]()
        
        let num_cards_in_arr = card_str_array.count * 2
        let randArray = MemorizeExt.get_unique_random_array(size: num_cards_in_arr)
        for index in 0..<num_cards_in_arr {
            let index_loc = randArray[index]
            let card_loc = card_array_loc[index_loc]
            card_array_reordered.append(card_loc)
        }
        
        emoji_themes[theme].theme_cards = card_array_reordered
        save_state()
    }
    
    mutating func remove_repeating_emoji(theme_id: Int, num_emoji: Int) {
        var emojis_loc = ""
        
        for i in 0..<num_emoji {
            let index_ref = emoji_themes[theme_id].emojis_str.index(emoji_themes[theme_id].emojis_str.startIndex, offsetBy: i)
            var is_not_duplicate = true
            for j in 0..<i {
                let index_curr = emoji_themes[theme_id].emojis_str.index(emoji_themes[theme_id].emojis_str.startIndex, offsetBy: j)
                let ref_elem = emoji_themes[theme_id].emojis_str[index_ref]
                let curr_elem = emoji_themes[theme_id].emojis_str[index_curr]
                let is_duplicate = ref_elem == curr_elem
                if is_duplicate {
                    is_not_duplicate = false
                }
            }
            if is_not_duplicate {
                emojis_loc = emojis_loc + String(emoji_themes[theme_id].emojis_str[index_ref])
            }
        }
        
        emoji_themes[theme_id].emojis_str = emojis_loc
    }

    // MARK: - Intent(s)
    
    mutating func add_new_theme() {
        let num_themes = emoji_themes.count
        let max_color_id = get_max_color_id()
        let theme_color_loc = get_color(theme_id: max_color_id + 1)
        let card_array = [Card]()
        let new_theme = Theme(emojis_str: "", theme_color: theme_color_loc, theme_name: "", id: num_themes, theme_color_id: max_color_id + 1, theme_cards: card_array)
        emoji_themes.append(new_theme)
        
        save_state()
    }
    
    func get_max_color_id() -> Int {
        let num_themes = emoji_themes.count
        var max_color_id: Int = -10
        for theme_index in 0..<num_themes {
            if emoji_themes[theme_index].theme_color_id > max_color_id {
                max_color_id = emoji_themes[theme_index].theme_color_id
            }
        }
        
        return max_color_id
    }
    
    func get_theme() -> Int {
        return theme
    }
    
    func get_color_of_theme_with_name(theme_name: String) -> Int {
        let num_themes_loc = emoji_themes.count
        var color_id_result: Int = 0
        for theme_index_loc in 0..<num_themes_loc {
            if emoji_themes[theme_index_loc].theme_name == theme_name {
                color_id_result = emoji_themes[theme_index_loc].theme_color_id
            }
        }
        
        return color_id_result
    }
    
    mutating func choose(theme_name: String, _ card: Card) {
        
        let num_themes_loc = emoji_themes.count
        for theme_index_loc in 0..<num_themes_loc {
            if emoji_themes[theme_index_loc].theme_name == theme_name {
                let theme_id = theme_index_loc
                
                theme = theme_id
                if let chosenIndex = index(theme_id: theme_id, of: card),
                   !emoji_themes[theme_id].theme_cards[chosenIndex].isFaceUp,
                    !emoji_themes[theme_id].theme_cards[chosenIndex].isMatched {
                    if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                        if emoji_themes[theme_id].theme_cards[chosenIndex].content == emoji_themes[theme_id].theme_cards[potentialMatchIndex].content {
                            emoji_themes[theme_id].theme_cards[chosenIndex].isMatched = true
                            emoji_themes[theme_id].theme_cards[potentialMatchIndex].isMatched = true
                            score = score + 2
                        }
                        else {
                            if emoji_themes[theme_id].theme_cards[chosenIndex].isSeen {
                                score = score - 1
                            }
                            if emoji_themes[theme_id].theme_cards[potentialMatchIndex].isSeen {
                                score = score - 1
                            }
                            emoji_themes[theme_id].theme_cards[chosenIndex].isSeen = true
                            emoji_themes[theme_id].theme_cards[potentialMatchIndex].isSeen = true
                        }
                        indexOfTheOneAndOnlyFaceUpCard = nil
                    }
                    else {
                        for index in 0..<emoji_themes[theme_id].theme_cards.count {
                            emoji_themes[theme_id].theme_cards[index].isFaceUp = false
                        }
                        indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                    }
                    emoji_themes[theme_id].theme_cards[chosenIndex].isFaceUp.toggle()
                }
            }
        }
    }
    
    func get_score() -> Int {
        return score
    }
    
    func index(theme_id: Int, of card: Card) -> Int? {
        for index in 0..<emoji_themes[theme_id].theme_cards.count {
            if emoji_themes[theme_id].theme_cards[index].id == card.id {
                return index
            }
        }
        return nil
    }
    
    mutating func new_game_with_name(theme_name: String) {

        score = 0
        
        let num_themes_loc = emoji_themes.count
        var theme_index: Int = 0
        for theme_index_loc in 0..<num_themes_loc {
            if theme_name == emoji_themes[theme_index_loc].theme_name {
                theme_index = theme_index_loc
            }
        }
        
        theme = theme_index
        
        let num_cards_loc = emoji_themes[theme_index].emojis_str.count * 2
        let randArray = MemorizeExt.get_unique_random_array(size: num_cards_loc)
        for index in 0..<num_cards_loc {
            let index_loc = randArray[index]
            emoji_themes[theme_index].theme_cards[index].isFaceUp = false
            emoji_themes[theme_index].theme_cards[index].isMatched = false
            emoji_themes[theme_index].theme_cards[index].isSeen = false
            emoji_themes[theme_index].theme_cards[index].content = create_card_content(theme_id: theme_index, index: Int(index_loc) / 2)
        }
        indexOfTheOneAndOnlyFaceUpCard = nil
    }
    
    func get_cards(theme_id: Int) -> [Card] {
        return emoji_themes[theme_id].theme_cards
    }
}
