//
//  ContentView.swift
//  Memorize
//
//  Created by mndx on 18/11/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: EmojiMemoryGame

    @Environment(\.presentationMode) var presentationMode
    @State private var editMode: EditMode = .inactive
    @State private var managing = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.emoji_themes) { emoji_theme in
                    ZStack { // This is the Z-stack hack
                        Button(action: {
                            let theme_local = get_actual_theme()
                            if theme_local.theme_name != emoji_theme.theme_name {
                                set_new_game(theme: emoji_theme.id)
                            }
                        })  {
                            VStack {
                                Text(emoji_theme.theme_name)
                                Text(String(emoji_theme.emojis_str))
                                ZStack {
                                    emoji_theme.theme_color
                                        .frame(width: 40)
                                    Text("")
                                }
                            }
                            .onTapGesture {
                                if editMode == .active {
                                    set_theme(id: emoji_theme.id)
                                    managing = true
                                }
                            }
                        }
                        .padding()
                        NavigationLink(destination: Game(viewModel: viewModel, theme_id: emoji_theme.id)) {}
                    }
                }
                .onDelete { indexSet in
                    remove_theme_with(theme_id: indexSet)
                }
                .onMove { indexSet, newOffset in
                    move_theme_to(fromOffsets: indexSet, toOffset: newOffset)
                }
                
                Button(action: {
                    add_new_theme()
                })  {
                    Text("Add new theme")
                }
                .padding()
            }
            .sheet(isPresented: $managing) {
                if editMode == .active {
                    ThemeEditor(viewModel: viewModel)
                }
            }
            .navigationTitle("Choose Theme")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem { EditButton() }
                ToolbarItem(placement: .navigationBarLeading) {
                    if presentationMode.wrappedValue.isPresented, UIDevice.current.userInterfaceIdiom != .pad {
                        Button("Close") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
            .environment(\.editMode, $editMode)
        }
    }
    
    func remove_theme_with(theme_id: IndexSet) {
        viewModel.remove_theme_with(theme_offset: theme_id)
    }
    
    func move_theme_to(fromOffsets: IndexSet, toOffset: Int) {
        viewModel.move_theme_to(fromOffsets: fromOffsets, toOffset: toOffset)
    }
    
    func theme_title() -> Text {
        let theme = viewModel.get_theme() + 1
        let prefix = "Theme: "
        let suffix = String(theme)
        return Text(prefix + suffix)
    }
    
    func set_theme(id: Int) {
        viewModel.set_theme(id: id)
    }
    
    func add_new_theme() {
        viewModel.add_new_theme()
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
    
    func get_theme() -> Int {
        return viewModel.get_theme()
    }

    func get_actual_theme() -> Theme {
        return viewModel.get_actual_theme()
    }
    
    func get_color_of_theme_with(id: Int) -> Color {
        return viewModel.get_color_of_theme_with(id: id)
    }
    
    func myAction () -> Void {
        viewModel.new_game()
    }
    
    func set_new_game(theme: Int) -> Void {
        viewModel.save_state()
        viewModel.new_game_with_id(id: theme)
    }
    
    func myLabel () -> Text {
        return Text("New Game")
    }
}

struct CardView: View {
    let card: MemoryGame.Card
    
    var body: some View {
        
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(card.content).font(.largeTitle)
            }
            else if card.isMatched {
                shape.opacity(0)
            }
            else {
                shape.fill()
                shape.strokeBorder(lineWidth: 3)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        
        Group {
            ContentView(viewModel: game)
                .preferredColorScheme(.light)
                .previewInterfaceOrientation(.portrait)
        }
    }
}
