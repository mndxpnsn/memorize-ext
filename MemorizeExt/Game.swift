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
    
    func get_theme_name_with(theme_name: String) -> Text {
        return Text(viewModel.get_theme_name_with(theme_name: theme_name))
    }
    
    func game_score() -> Text {
        let score = viewModel.get_score()
        let prefix = "Score: "
        let suffix = String(score)
        return Text(prefix + suffix)
    }
    
    func get_color_of_theme_with_name(theme_name: String) -> Color {
        return viewModel.get_color_of_theme_with_name(theme_name: theme_name)
    }
    
    func set_new_game_with_name(theme_name: String) -> Void {
        viewModel.new_game_with_name(theme_name: theme_name)
    }
    
    func myLabel () -> Text {
        return Text("New Game")
    }
}
