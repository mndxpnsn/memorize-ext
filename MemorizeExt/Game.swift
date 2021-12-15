//
//  Game.swift
//  MemorizeExt
//
//  Created by mndx on 08/12/2021.
//

import SwiftUI

struct Game: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    @State var theme_name: String
    
    var body: some View {
        let color = get_color_of_theme_with_name(theme_name: theme_name)
        let theme_name = viewModel.get_theme_name_with(theme_name: theme_name)
        VStack {
            Text(theme_name)
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 75))]) {
                    ForEach(viewModel.get_cards_with_name(theme_name: theme_name), content: { card in
                        CardView(card: card)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                viewModel.choose(theme_name: theme_name, card)
                            }
                    })
                }
            }
            .foregroundColor(color)
            .padding(.horizontal)

            HStack {
                Button(action: {
                    set_new_game_with_name(theme_name: theme_name)
                }) {
                    myLabel()
                    Spacer()
                    game_score()
                }
            }
            .padding(.horizontal)
            .padding(.vertical)
        }
    }
    
    func theme_title() -> Text {
        let theme = viewModel.get_theme() + 1
        let prefix = "Theme: "
        let suffix = String(theme)
        return Text(prefix + suffix)
    }
    
    func set_theme(id: Int) -> Void {
        viewModel.set_theme(id: id)
    }
    
    func get_theme_name_with(theme_name: String) -> Text {
        return Text(viewModel.get_theme_name_with(theme_name: theme_name))
    }
    
    func theme_title_with(id: Int) -> Text {
        let theme = id
        let prefix = "Theme: "
        let suffix = String(theme)
        return Text(prefix + suffix)
    }
    
    func game_score() -> Text {
        let score = viewModel.get_score()
        let prefix = "Score: "
        let suffix = String(score)
        return Text(prefix + suffix)
    }
    
    func get_theme_color() -> Color {
        return viewModel.get_theme_color()
    }

    func get_color_of_theme_with(id: Int) -> Color {
        return viewModel.get_color_of_theme_with(id: id)
    }
    
    func get_color_of_theme_with_name(theme_name: String) -> Color {
        return viewModel.get_color_of_theme_with_name(theme_name: theme_name)
    }
    
    func myAction () -> Void {
        viewModel.new_game()
    }
    
    func set_new_game_with_name(theme_name: String) -> Void {
        viewModel.new_game_with_name(theme_name: theme_name)
    }
    
    func myLabel () -> Text {
        return Text("New Game")
    }
}
