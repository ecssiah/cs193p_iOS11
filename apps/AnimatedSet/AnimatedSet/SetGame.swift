//
//  SetGame.swift
//  GraphicalSet
//
//  Created by Michael Chapman on 4/12/19.
//  Copyright © 2019 Gauge Structures. All rights reserved.
//

import Foundation

struct SetGame
{
    private(set) var deck = [Card]()
    
    private(set) var playedCards = [Card]()
    private(set) var discardedCards = [Card]()
    private(set) var selectedCards = [Card]()
    
    var cardsInDeck: [Card] {
        return deck.filter {
            !playedCards.contains($0) && !discardedCards.contains($0)
        }
    }
    
    mutating func shuffle() {
        playedCards.shuffle()
    }
    
    mutating private func resetDeck() {
        selectedCards.removeAll()
        playedCards.removeAll()
        discardedCards.removeAll()
        
        deck.shuffle()
    }
    
    private func findSet() -> (Card, Card, Card)? {
        for idx1 in playedCards.indices {
            for idx2 in (idx1 + 1)..<playedCards.count {
                for idx3 in (idx2 + 1)..<playedCards.count {
                    let card1 = playedCards[idx1]
                    let card2 = playedCards[idx2]
                    let card3 = playedCards[idx3]
                    
                    let setFound = makesSet(
                        first: card1, second: card2, third: card3
                    )
                    
                    if setFound {
                        return (card1, card2, card3)
                    }
                }
            }
        }
        
        return nil
    }
    
    mutating private func createDeck() {
        for feature1 in Card.Variant.allCases {
            for feature2 in Card.Variant.allCases {
                for feature3 in Card.Variant.allCases {
                    for feature4 in Card.Variant.allCases {
                        let card = Card(
                            feature1: feature1,
                            feature2: feature2,
                            feature3: feature3,
                            feature4: feature4
                        )
                        
                        deck += [card]
                    }
                }
            }
        }
        
        deck.shuffle()
    }
    
    mutating func newGame() {
        resetDeck()
        
        deal(thisMany: 12)
    }
    
    mutating func chooseCard(_ card: Card) {
        if selectedCards.contains(card) {
            selectedCards.remove(at: selectedCards.firstIndex(of: card)!)
        } else {
            selectedCards.append(card)
            
            if selectedCards.count == 3 {
                checkForMatch()
            }
        }
    }
    
    mutating func checkForMatch() {
        let completeSet = makesSet(
            first: selectedCards[0],
            second: selectedCards[1],
            third: selectedCards[2]
        )
        
        if true || completeSet {
            playedCards = playedCards.filter { card in
                let matchFirst = card != selectedCards[0]
                let matchSecond = card != selectedCards[1]
                let matchThird = card != selectedCards[2]
                
                return matchFirst && matchSecond && matchThird
            }
            
            discardedCards.insert(
                contentsOf: [selectedCards[0], selectedCards[1], selectedCards[2]],
                at: 0
            )
            
            deal(thisMany: 3)
        }
        
        selectedCards.removeAll()
    }
    
    mutating func deal(thisMany numCards: Int) {
        for _ in 1...numCards {
            if cardsInDeck.count == 0 {
                break
            }
            
            playedCards.append(cardsInDeck.last!)
        }
    }
    
    func makesSet(first: Card, second: Card, third: Card) -> Bool {
        let feature1Set = traitCheck(
            first: first.feature1,
            second: second.feature1,
            third: third.feature1
        )
        let feature2Set = traitCheck(
            first: first.feature2,
            second: second.feature2,
            third: third.feature2
        )
        let feature3Set = traitCheck(
            first: first.feature3,
            second: second.feature3,
            third: third.feature3
        )
        let feature4Set = traitCheck(
            first: first.feature4,
            second: second.feature4,
            third: third.feature4
        )

        return feature1Set && feature2Set && feature3Set && feature4Set
    }
    
    func traitCheck(first: Card.Variant, second: Card.Variant, third: Card.Variant) -> Bool {
        return Set([first, second, third]).count != 2
    }
    
    init() {
        createDeck()
    }
}
