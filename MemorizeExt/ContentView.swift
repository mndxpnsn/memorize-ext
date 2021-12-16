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
        if editMode == .inactive {
            NavigationView {
                List {
                    ForEach(viewModel.get_emoji_themes()) { emoji_theme in
                        NavigationLink(destination: Game(viewModel: viewModel, theme_name: emoji_theme.theme_name)) {
                            VStack {
                                Text(emoji_theme.theme_name)
                                Text(String(emoji_theme.emojis_str))
                                ZStack {
                                    emoji_theme.theme_color
                                        .frame(width: 40)
                                    Text("")
                                }
                            }
                        }
                        .padding()
                    }
                    .onDelete { indexSet in
                        remove_theme_with(theme_id: indexSet)
                    }
                    .onMove { indexSet, newOffset in
                        move_theme_to(fromOffsets: indexSet, toOffset: newOffset)
                    }
                    
                    Button(action: {
                        add_new_theme()
                        print("added new theme")
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
        
        if editMode == .active {
            NavigationView {
                List {
                    ForEach(viewModel.get_emoji_themes()) { emoji_theme in
                        
                        VStack {
                            Text(emoji_theme.theme_name)
                            Text(String(emoji_theme.emojis_str))
                            ZStack {
                                emoji_theme.theme_color
                                    .frame(width: 40)
                                Text("")
                            }
                        }
                        .padding()
                        .onTapGesture {
                            managing = true
                            set_theme_with_name(theme_name: emoji_theme.theme_name)
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
                        print("added new theme")
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
    }
    
    func remove_theme_with(theme_id: IndexSet) {
        viewModel.remove_theme_with(theme_offset: theme_id)
    }
    
    func move_theme_to(fromOffsets: IndexSet, toOffset: Int) {
        viewModel.move_theme_to(fromOffsets: fromOffsets, toOffset: toOffset)
    }
    
    func set_theme_with_name(theme_name: String) {
        viewModel.set_theme_with_name(theme_name: theme_name)
    }
    
    func add_new_theme() {
        viewModel.add_new_theme()
    }
}

struct CardView: View {
    let card: Card
    
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
