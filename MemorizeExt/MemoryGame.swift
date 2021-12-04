//
//  MemoryGame.swift
//  Memorize
//  This is the model
//  Created by mndx on 20/11/2021.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
    private var numberOfCards: Int
    private var score: Int
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = Array<Card>()
        numberOfCards = 2 * numberOfPairsOfCards
        score = 0

        let randArray = get_unique_random_array(size: numberOfCards)
        
        for index in 0..<numberOfCards {
            let index_loc = randArray[index]
            let pairIndex = index_loc / 2
            let content: CardContent = createCardContent(pairIndex)
            cards.append(Card(content: content, id: index))
        }
    }
    
    func get_unique_random_array(size: Int) -> Array<Int> {
        var set = Set<Int>()
        while set.count < size {
            set.insert(Int.random(in: 0..<size))
        }
        let randArray = Array(set)
        
        return randArray
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = index(of: card),
            !cards[chosenIndex].isFaceUp,
            !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score = score + 2
                }
                else {
                    if cards[chosenIndex].isSeen {
                        score = score - 1
                    }
                    if cards[potentialMatchIndex].isSeen {
                        score = score - 1
                    }
                    cards[chosenIndex].isSeen = true
                    cards[potentialMatchIndex].isSeen = true
                }
                indexOfTheOneAndOnlyFaceUpCard = nil
            }
            else {
                for index in 0..<cards.count {
                    cards[index].isFaceUp = false
                }
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp.toggle()
        }
    }
    
    func get_score() -> Int {
        return score
    }
    
    func index(of card: Card) -> Int? {
        for index in 0..<cards.count {
            if cards[index].id == card.id {
                return index
            }
        }
        return nil
    }
    
    mutating func new_cards(num_cards: Int, createCardContent: (Int) -> CardContent) {
        cards = Array<Card>()
        numberOfCards = num_cards
        
        let randArray = get_unique_random_array(size: num_cards)
        
        for index in 0..<num_cards {
            let index_loc = randArray[index]
            let pairIndex = index_loc / 2
            let content: CardContent = createCardContent(pairIndex)
            cards.append(Card(content: content, id: index))
        }
    }
    
    mutating func new_game(num_cards: Int, cardContent: (Int) -> CardContent) {

        score = 0
        numberOfCards = num_cards
        
        new_cards(num_cards: num_cards, createCardContent: cardContent)
        
        let randArray = get_unique_random_array(size: num_cards)
        for index in 0..<num_cards {
            let index_loc = randArray[index]
            cards[index].isFaceUp = false
            cards[index].isMatched = false
            cards[index].isSeen = false
            cards[index].content = cardContent(Int(index_loc) / 2)
        }
        indexOfTheOneAndOnlyFaceUpCard = nil
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var isSeen: Bool = false
        var content: CardContent
        var id: Int
    }
}
