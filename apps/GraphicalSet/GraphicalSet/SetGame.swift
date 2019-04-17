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
    enum User {
        case human
        case siri
    }
    
    private let numCards = 24

    private(set) var playerScore = 0
    private(set) var siriScore = 0
    
    private(set) var lastPlayerMoveTime: DispatchTime
    private(set) var lastSiriMoveTime: DispatchTime
    
    private(set) var cardsInDeck = [Card]()
    private(set) var cardsInPlay = [Card]()
    
    private(set) var selectedCards = [Card]()
    
    var deckEmpty: Bool {
        return cardsInDeck.count == 0
    }
    
    var full: Bool {
        return cardsInPlay.count == numCards
    }
    
    var over: Bool {
        if cardsInDeck.count == 0 && cardsInPlay.count == 0 {
            return true
        }
        
        if findSet() == nil {
            let boardFull = cardsInPlay.count == numCards
            let noCardsLeft = cardsInDeck.count == 0
            
            if boardFull || noCardsLeft {
                return true
            }
        }
        
        return false
    }
    
    mutating private func resetDeck() {
        selectedCards.removeAll()
        cardsInPlay.removeAll()
        
        createDeck()
    }
    
    mutating func resetSiri() {
        siriScore = 0
    }
    
    mutating func calculateDealingPenalty() {
        if findSet() != nil {
            playerScore -= 2
        }
    }
    
    private func findSet() -> (Card, Card, Card)? {
        for idx1 in cardsInPlay.indices {
            for idx2 in (idx1 + 1)..<cardsInPlay.count {
                for idx3 in (idx2 + 1)..<cardsInPlay.count {
                    let card1 = cardsInPlay[idx1]
                    let card2 = cardsInPlay[idx2]
                    let card3 = cardsInPlay[idx3]
                    
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
        cardsInDeck.removeAll()
        
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
                        
                        cardsInDeck += [card]
                    }
                }
            }
        }
    }
    
    mutating func newGame() {
        playerScore = 0
        siriScore = 0
        
        resetDeck()
        
        deal(thisMany: 18)
        
        lastPlayerMoveTime = DispatchTime.now()
    }
    
    mutating func getSpeedBonus(for user: User) -> Int {
        var elapsed: Double
        let now = DispatchTime.now()
        
        if user == User.human {
            elapsed = Double(now.rawValue - lastPlayerMoveTime.rawValue) / 1e+9
            lastPlayerMoveTime = now
        } else {
            elapsed = Double(now.rawValue - lastSiriMoveTime.rawValue) / 1e+9
            lastSiriMoveTime = now
        }
        
        if elapsed < 10 {
            return 2
        } else if elapsed < 20 {
            return 1
        } else {
            return 0
        }
    }
    
    func getCardBonus() -> Int {
        if cardsInPlay.count <= 9 {
            return 5
        } else if cardsInPlay.count <= 12 {
            return 3
        } else if cardsInPlay.count <= 15 {
            return 2
        } else if cardsInPlay.count <= 18 {
            return 1
        } else {
            return 0
        }
    }
    
    mutating func chooseCard(card: Card) {
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
        
        if completeSet {
            playerScore += 3 + getSpeedBonus(for: User.human) + getCardBonus()
            
            cardsInPlay = cardsInPlay.filter({(card: Card) in
                let matchFirst = card != selectedCards[0]
                let matchSecond = card != selectedCards[1]
                let matchThird = card != selectedCards[2]
                
                return matchFirst && matchSecond && matchThird
            })
        } else {
            playerScore -= 5
        }
        
        selectedCards.removeAll()
    }
    
    mutating func deal() -> Card {
        let card = cardsInDeck.remove(
            at: Int(arc4random_uniform(UInt32(cardsInDeck.count)))
        )
        
        cardsInPlay.append(card)
        
        return card
    }
    
    mutating func deal(thisMany numCards: Int) {
        for _ in 1...numCards {
            if cardsInDeck.count == 0 {
                break
            }
            
            let card = cardsInDeck.remove(
                at: Int(arc4random_uniform(UInt32(cardsInDeck.count)))
            )
            
            cardsInPlay.append(card)
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
    
    func traitCheck(
        first: Card.Variant, second: Card.Variant, third: Card.Variant
    ) -> Bool {
        return Set([first, second, third]).count != 2
    }
    
    mutating func siriMove() {
        lastSiriMoveTime = DispatchTime.now()
        
        if let foundSet = findSet() {
            siriScore += 3 + getCardBonus() + getSpeedBonus(for: User.siri)
            
            cardsInPlay = cardsInPlay.filter({(card: Card) in
                let matchFirst = card != foundSet.0
                let matchSecond = card != foundSet.1
                let matchThird = card != foundSet.2
                
                return matchFirst && matchSecond && matchThird
            })
        }
        
        selectedCards.removeAll()
    }
    
    init() {
        lastPlayerMoveTime = DispatchTime.now()
        lastSiriMoveTime = DispatchTime.now()
        
        createDeck()
        newGame()
    }
}
