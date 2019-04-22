//
//  ViewController.swift
//  GraphicalSet
//
//  Created by Michael Chapman on 4/12/19.
//  Copyright © 2019 Gauge Structures. All rights reserved.
//

import UIKit

class CardTapGestureRecognizer : UITapGestureRecognizer
{
    let card: Card
    
    init(target: Any?, action: Selector?, card: Card) {
        self.card = card
        super.init(target: target, action: action)
    }
}

class ViewController: UIViewController
{
    private var game = SetGame()
    private var grid = Grid(layout: Grid.Layout.aspectRatio(CGFloat(3.0/4.0)))

    @IBOutlet
    weak var cardAreaView: UIView! {
        didSet {
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(rotateCards(recognizer:)))
            cardAreaView.addGestureRecognizer(rotate)
        }
    }
    
    @IBOutlet
    weak var deckArea: UIView!
    
    @IBOutlet
    weak var deckView: UIView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(deal))
            deckView.addGestureRecognizer(tap)
        }
    }
    
    @IBOutlet
    weak var discardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCardViews()
        
        updateView()
    }

    override func viewDidLayoutSubviews() {
        let cardsInDeck = game.deck.filter {
            !game.playedCards.contains($0) || !game.discardedCards.contains($0)
        }
        
        let initialFrame = cardAreaView.convert(deckView.frame, from: deckArea)
        
        for card in cardsInDeck {
            let cardViews = cardAreaView.subviews.compactMap { $0 as? CardView }
            
            if let cardView = cardViews.first(where: { $0.card == card }) {
                cardView.frame = initialFrame
            }
        }
        
        let discardFrame = cardAreaView.convert(discardView.frame, from: deckArea)
        
        print(discardFrame)
        
        for card in game.discardedCards {
            let cardViews = cardAreaView.subviews.compactMap { $0 as? CardView }
            
            if let cardView = cardViews.first(where: { $0.card == card }) {
                cardView.frame = discardFrame
            }
        }
        
        grid.frame = cardAreaView.bounds
        grid.cellCount = game.playedCards.count
        
        for index in game.playedCards.indices {
            let card = game.playedCards[index]
            let cardViews = cardAreaView.subviews.compactMap { $0 as? CardView }
            
            if let cardView = cardViews.first(where: { $0.card == card }) {
                cardView.frame = grid[index]!.insetBy(
                    dx: CardView.inset, dy: CardView.inset
                )
            }
        }
    }
    
    @objc
    private func deal() {
        game.deal(thisMany: 3)
        
        updateView()
    }
    
    @objc
    private func touchCard(sender: CardTapGestureRecognizer) {
        game.chooseCard(sender.card)
        
        updateView()
    }
    
    @objc
    private func rotateCards(recognizer: UIRotationGestureRecognizer) {
        if recognizer.state == .ended {
            game.shuffle()
        }
    }
    
    private func updateView() {
        grid.frame = cardAreaView.bounds
        grid.cellCount = game.playedCards.count
        
        var newCardCount = 0
        
        for index in game.playedCards.indices {
            let card = game.playedCards[index]
            let cardViews = cardAreaView.subviews.compactMap { $0 as? CardView }

            if let cardView = cardViews.first(where: { $0.card == card }) {
                if game.selectedCards.contains(card) {
                    cardView.selected = true
                } else {
                    cardView.selected = false
                }
                
                let initialFrame = cardAreaView.convert(deckView.frame, from: deckArea)
                
                cardAreaView.bringSubviewToFront(cardView)
                
                if cardView.frame == initialFrame {
                    Timer.scheduledTimer(
                        withTimeInterval: 0.4 * Double(newCardCount),
                        repeats: false,
                        block: { timer in
                            UIView.transition(
                                with: cardView,
                                duration: 1.5,
                                options: [.transitionFlipFromTop],
                                animations: {
                                    cardView.faceUp = true
                                }
                            )
                        }
                    )
                    
                    if let frame = grid[index]?.insetBy(dx: CardView.inset, dy: CardView.inset) {
                        UIViewPropertyAnimator.runningPropertyAnimator(
                            withDuration: 1.5,
                            delay: 0.4 * Double(newCardCount),
                            options: [],
                            animations: {
                                cardView.frame = frame
                            }
                        )
                    }
                    
                    newCardCount += 1
                } else {
                    if let frame = grid[index]?.insetBy(dx: CardView.inset, dy: CardView.inset) {
                        UIViewPropertyAnimator.runningPropertyAnimator(
                            withDuration: 1.5,
                            delay: 0.4,
                            options: [],
                            animations: {
                                cardView.frame = frame
                            }
                        )
                    }
                }
            }
        }
        
        for card in game.discardedCards {
            let cardViews = cardAreaView.subviews.compactMap { $0 as? CardView }
            
            let discardFrame = cardAreaView.convert(discardView.frame, from: deckArea)
            
            if let cardView = cardViews.first(where: { $0.card == card }) {
                if cardView.frame != discardFrame {
                    cardAreaView.bringSubviewToFront(cardView)
                    
                    Timer.scheduledTimer(
                        withTimeInterval: 0.4,
                        repeats: false,
                        block: { timer in
                            UIView.transition(
                                with: cardView,
                                duration: 2.0,
                                options: [.transitionFlipFromTop],
                                animations: {
                                    cardView.faceUp = false
                                }
                            )
                        }
                    )
                    
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 3.0,
                        delay: 0.0,
                        options: [],
                        animations: {
                            cardView.frame = discardFrame
                        },
                        completion: { position in
                            
                        }
                    )
                }
            }
        }
    }
    
    func setupCardViews() {
        let initialFrame = cardAreaView.convert(deckView.frame, from: deckArea)
        
        for card in game.deck {
            let cardView = CardView(frame: initialFrame)
            cardView.card = card
            cardView.backgroundColor = UIColor.clear
            
            cardAreaView.addSubview(cardView)
            
            let cardTap = CardTapGestureRecognizer(target: self, action: #selector(touchCard), card: card)
            cardView.addGestureRecognizer(cardTap)
        }
    }
}
