//
//  MemoryGame.swift
//  Memorize
//  This is the model
//  Created by mndx on 20/11/2021.
//

import SwiftUI
import Foundation

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
var max_theme_color_id: Int = 0

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

func create_card_content2(theme_id: Int, index: Int) -> String {
    let index_str = emoji_themes_glb[theme_id].emojis_str.index(emoji_themes_glb[theme_id].emojis_str.startIndex, offsetBy: index)
    let index_str_upb = emoji_themes_glb[theme_id].emojis_str.index(emoji_themes_glb[theme_id].emojis_str.startIndex, offsetBy: index + 1)
    return String(emoji_themes_glb[theme_id].emojis_str[index_str..<index_str_upb])
}

func createMemoryGame() -> MemoryGame {
    if state_read == false {
//        read_state()
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

    var emojis_loc = Theme(emojis_str: "", theme_color: Color.cyan, theme_name: theme_name, id: theme_counter, theme_color_id: theme_counter, theme_cards: [Card]())
    let num_pairs = emojis.count
    
    emojis_loc.id = theme_counter
    emojis_loc.theme_name = theme_name
    emojis_loc.theme_color = get_color(theme_id: theme_counter)
    emojis_loc.theme_color_id = theme_counter
    
    var card_array: [Card] = [Card]()
    
    for index in 0..<num_pairs {
        emojis_loc.emojis_str = emojis_loc.emojis_str + emojis[index]
        let card_content_loc = convert_emojis_str_to_cards(emojis: emojis_loc.emojis_str)
        let card_loc = Card(isFaceUp: false, isMatched: false, isSeen: false, content: card_content_loc[index], id: index)
        card_array.append(card_loc)
    }
    emojis_loc.theme_cards = card_array
    max_theme_color_id = theme_counter

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
            
            let num_cards_in_arr = emoji_array.count
            for card_elem in 0..<num_cards_in_arr {
                let elem_loc = Card(isFaceUp: false, isMatched: false, isSeen: false, content: emoji_array[card_elem], id: card_elem)
                card_array.append(elem_loc)
            }
            
            let color_theme = get_color(theme_id: color_id_theme)
            theme_elem = Theme(emojis_str: emojis_theme, theme_color: color_theme, theme_name: name_theme, id: id_theme, theme_color_id: color_id_theme, theme_cards: card_array)
            theme_colors.append(color_theme)
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

struct file_struct {
    var emojis: String
    var theme_name: String
    var id: Int
}

let color: Int = 0

struct MemoryGame {
    private(set) var cards: Array<Card>
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
    private var numberOfCards: Int
    private var score: Int

    private(set) var emoji_themes: [Theme] = [Theme]()
    
    func get_emoji_themes() -> [Theme] {
        return emoji_themes
    }
    
    func save_state() {}
    
    func set_theme(id: Int) {
        theme = id
    }
    
    func get_actual_theme() -> Theme {
        return emoji_themes[theme]
    }
    
    func get_emojis_of_theme(theme_id: Int) -> String {
        return String(emoji_themes[theme].emojis_str)
    }
    
    mutating func remove_theme_with(theme_offset: IndexSet) {
        withAnimation {
            emoji_themes.remove(atOffsets: theme_offset)
        }
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
    
    func get_unique_random_array(size: Int, diff: Int) -> Array<Int> {
        var set = Set<Int>()
        while set.count < size - diff {
            set.insert(Int.random(in: 0..<size))
        }
        let randArray = Array(set)
        
        return randArray
    }
    
    mutating func add_emojis(theme: Int, emojis_str: String) {
        withAnimation {
            emoji_themes[theme].emojis_str = (emojis_str + emoji_themes[theme].emojis_str)
        }
        let num_emoji = emoji_themes[theme].emojis_str.count
        remove_repeating_emoji(num_emoji: num_emoji)
        
        save_state()
    }
    
    mutating func change_to_name(theme: Int, text: String) {
        emoji_themes[theme].theme_name = text
        
        save_state()
    }
    
    func get_theme_name_with(id: Int) -> String {
        return emoji_themes[id].theme_name
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
        
        save_state()
    }
    
    mutating func remove_repeating_emoji(num_emoji: Int) {
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

    // MARK: - Intent(s)
    
    mutating func add_new_theme() {
        let num_themes = emoji_themes.count
        let max_color_id = get_max_color_id()
        let theme_color_loc = get_color(theme_id: max_color_id + 1)
        let card_array = [Card]()
        let new_theme = Theme(emojis_str: "", theme_color: theme_color_loc, theme_name: "", id: num_themes, theme_color_id: max_color_id + 1, theme_cards: card_array)
        emoji_themes.append(new_theme)
        theme_colors.append(theme_color_loc)
        
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
    
    func get_theme_color() -> Color {
        return get_color(theme_id: emoji_themes[theme].theme_color_id)
    }
    
    func get_color_of_theme_with(id: Int) -> Color {
        return get_color(theme_id: emoji_themes[id].theme_color_id)
    }
    
    func get_cards_of(theme_id: Int) -> [Card] {
        return emoji_themes[theme_id].theme_cards
    }
    
    func get_score_wrap() -> Int {
        return get_score()
    }
    
    
    
    
    ///
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> String) {
        cards = Array<Card>()
        numberOfCards = 2 * numberOfPairsOfCards
        score = 0

        let randArray = get_unique_random_array(size: numberOfCards)
        
        for index in 0..<numberOfCards {
            let index_loc = randArray[index]
            let pairIndex = index_loc / 2
            let content: String = createCardContent(pairIndex)
            cards.append(Card(content: content, id: index))
        }
        
        if state_read == false {
//            read_state()
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
    
    func get_unique_random_array(size: Int) -> Array<Int> {
        var set = Set<Int>()
        while set.count < size {
            set.insert(Int.random(in: 0..<size))
        }
        let randArray = Array(set)
        
        return randArray
    }
    
    mutating func choose(theme_id: Int, _ card: Card) {
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
    
    func get_score() -> Int {
        return score
    }
    
    func index(theme_id: Int, of card: Card) -> Int? {
        for index in 0..<cards.count {
            if emoji_themes[theme_id].theme_cards[index].id == card.id {
                return index
            }
        }
        return nil
    }
    
    mutating func new_cards(num_cards: Int, createCardContent: (Int) -> String) {
        cards = Array<Card>()
        numberOfCards = num_cards
        
        let randArray = get_unique_random_array(size: num_cards)
        
        for index in 0..<num_cards {
            let index_loc = randArray[index]
            let pairIndex = index_loc / 2
            let content: String = createCardContent(pairIndex)
            cards.append(Card(content: content, id: index))
        }
    }
    
    mutating func new_game() {
        
        score = 0
        numberOfCards = emoji_themes[theme].emojis_str.count * 2
        let randArray = get_unique_random_array(size: numberOfCards)
        for index in 0..<numberOfCards {
            let index_loc = randArray[index]
            cards[index].isFaceUp = false
            cards[index].isMatched = false
            cards[index].isSeen = false
            cards[index].content = create_card_content(index: Int(index_loc) / 2)
        }
        indexOfTheOneAndOnlyFaceUpCard = nil
    }
    
    mutating func new_game_with_id(id: Int) {
        theme = id
        score = 0
        numberOfCards = emoji_themes[theme].emojis_str.count * 2
        let randArray = get_unique_random_array(size: numberOfCards)
        for index in 0..<numberOfCards {
            let index_loc = randArray[index]
            cards[index].isFaceUp = false
            cards[index].isMatched = false
            cards[index].isSeen = false
            cards[index].content = create_card_content(index: Int(index_loc) / 2)
        }
        indexOfTheOneAndOnlyFaceUpCard = nil
    }
    
    func get_cards(theme_id: Int) -> [Card] {
        return emoji_themes[theme_id].theme_cards
    }
}
