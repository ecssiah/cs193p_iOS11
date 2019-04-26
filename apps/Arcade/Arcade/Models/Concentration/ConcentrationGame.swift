//
//  ConcentrationGame.swift
//  Arcade
//
//  Created by Michael Chapman on 4/26/19.
//  Copyright © 2019 Gauge Structures. All rights reserved.
//

import Foundation

struct Concentration
{
    private(set) var cards = [ConcentrationCard]()
    
    private var indexOfOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.onlyOne
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func chooseCard(at index: Int) {
        assert(
            cards.indices.contains(index),
            "Concentration.chooseCard(\(index)): Chosen index not in range"
        )
        
        if !cards[index].isMatched {
            if let matchIndex = indexOfOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOnlyFaceUpCard = index
            }
        }
    }
    
    init(numCardPairs: Int) {
        assert(
            numCardPairs > 0,
            "Concentration.init(\(numCardPairs)): Must have one pair of cards"
        )
        
        for _ in 0..<numCardPairs {
            let card = ConcentrationCard()
            cards += [card, card]
        }
        
        cards.shuffle()
    }
}

extension Collection {
    var onlyOne: Element? {
        return count == 1 ? first : nil
    }
}
