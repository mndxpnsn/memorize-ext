//
//  Game.swift
//  MemorizeExt
//
//  Created by mndx on 08/12/2021.
//

import SwiftUI

struct Game: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    @State var theme_id: Int
    
    var body: some View {
        let color = get_color_of_theme_with(id: theme_id)
        VStack {
            get_theme_name_with(id: theme_id)
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 75))]) {
                    ForEach(viewModel.get_cards_of(theme_id: theme_id), content: { card in
                        CardView(card: card)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                viewModel.choose(theme_id: theme_id, card)
                            }
                    })
                }
            }
            .foregroundColor(color)
            .padding(.horizontal)

            HStack {
                Button(action: myAction, label: myLabel)
                Spacer()
                game_score()
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
    
    func get_theme_name_with(id: Int) -> Text {
        return Text(viewModel.get_theme_name_with(id: id))
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
    
    func myAction () -> Void {
        viewModel.new_game()
    }
    
    func set_new_game(theme: Int) -> Void {
        viewModel.new_game_with_id(id: theme)
    }
    
    func myLabel () -> Text {
        return Text("New Game")
    }
}
