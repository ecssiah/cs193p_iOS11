//
//  SetViewController.swift
//  Arcade
//
//  Created by Michael Chapman on 4/25/19.
//  Copyright © 2019 Gauge Structures. All rights reserved.
//

import UIKit

class CardTapGestureRecognizer : UITapGestureRecognizer
{
    let card: SetCard
    
    init(target: Any?, action: Selector?, card: SetCard) {
        self.card = card
        super.init(target: target, action: action)
    }
}


class SetViewController: UIViewController
{
    private var game = SetGame()
    private var grid = Grid(layout: Grid.Layout.aspectRatio(CGFloat(3.0/4.0)))
    
    @IBOutlet weak var cardAreaView: UIView! {
        didSet {
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(rotateCards(recognizer:)))
            cardAreaView.addGestureRecognizer(rotate)
        }
    }
    
    @IBOutlet weak var deckArea: UIView!
    
    @IBOutlet weak var deckView: UIView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(deal))
            deckView.addGestureRecognizer(tap)
        }
    }
    
    @IBOutlet weak var discardView: UIView!
    
    @IBOutlet weak var discardLabel: UILabel! { didSet { discardLabel.text = "" } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCardViews()
        
        Timer.scheduledTimer(
            withTimeInterval: 1.0,
            repeats: false,
            block: { timer in self.startGame() }
        )
    }
    
    override func viewDidLayoutSubviews() {
        updateLayout()
    }
    
    private func startGame() {
        game.newGame()
        updateView()
    }
    
    private func setupCardViews() {
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
    
    private func updateGrid() {
        grid.frame = cardAreaView.bounds
        grid.cellCount = game.playedCards.count
    }
    
    private func updateLayout() {
        deckArea.layoutIfNeeded()
        
        updatePlayedCardsLayout()
        updateDeckLayout()
        updateDiscardedCardsLayout()
    }
    
    private func updatePlayedCardsLayout() {
        updateGrid()
        
        for index in game.playedCards.indices {
            let card = game.playedCards[index]
            let cardViews = cardAreaView.subviews.compactMap { $0 as? CardView }
            
            if let cardView = cardViews.first(where: { $0.card == card }) {
                if let frame = grid[index] {
                    cardView.frame = frame.insetBy(dx: CardView.inset, dy: CardView.inset)
                }
            }
        }
    }
    
    private func updateDeckLayout() {
        let initialFrame = cardAreaView.convert(deckView.frame, from: deckArea)
        
        for card in game.cardsInDeck {
            let cardViews = cardAreaView.subviews.compactMap { $0 as? CardView }
            
            if let cardView = cardViews.first(where: { $0.card == card }) {
                cardView.frame = initialFrame
            }
        }
    }
    
    private func updateDiscardedCardsLayout() {
        let discardFrame = cardAreaView.convert(discardView.frame, from: deckArea)
        
        for card in game.discardedCards {
            let cardViews = cardAreaView.subviews.compactMap { $0 as? CardView }
            
            if let cardView = cardViews.first(where: { $0.card == card }) {
                cardView.frame = discardFrame
            }
        }
    }
    
    private func updateView() {
        updatePlayedCardsView()
        updateDiscardedCardsView()
    }
    
    private func updatePlayedCardsView() {
        updateGrid()
        
        var newCardIndex = -1
        
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
                
                if cardView.frame == initialFrame {
                    newCardIndex += 1
                    
                    Timer.scheduledTimer(
                        withTimeInterval: 0.4 * Double(newCardIndex),
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
                    
                    if let frame = grid[index] {
                        UIViewPropertyAnimator.runningPropertyAnimator(
                            withDuration: 1.5,
                            delay: 0.4 * Double(newCardIndex),
                            options: [],
                            animations: {
                                cardView.frame = frame.insetBy(dx: CardView.inset, dy: CardView.inset)
                            }
                        )
                    }
                } else {
                    if let frame = grid[index] {
                        UIViewPropertyAnimator.runningPropertyAnimator(
                            withDuration: 1.0,
                            delay: 0.0,
                            options: [],
                            animations: {
                                cardView.frame = frame.insetBy(dx: CardView.inset, dy: CardView.inset)
                            }
                        )
                    }
                }
            }
        }
    }
    
    private func updateDiscardedCardsView() {
        for card in game.discardedCards {
            let cardViews = cardAreaView.subviews.compactMap { $0 as? CardView }
            
            if let cardView = cardViews.first(where: { $0.card == card }) {
                let discardFrame = cardAreaView.convert(discardView.frame, from: deckArea)
                
                if cardView.frame != discardFrame {
                    cardAreaView.bringSubviewToFront(cardView)
                    
                    Timer.scheduledTimer(
                        withTimeInterval: 0.5,
                        repeats: false,
                        block: { timer in
                            UIView.transition(
                                with: cardView,
                                duration: 1.0,
                                options: [.transitionFlipFromBottom],
                                animations: {
                                    cardView.faceUp = false
                                }
                            )
                        }
                    )
                    
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 1.5,
                        delay: 0.0,
                        options: [],
                        animations: {
                            cardView.frame = discardFrame
                        },
                        completion: { position in
                            self.updateMatchedSetLabel()
                        }
                    )
                }
            }
        }
    }
    
    @objc private func deal() {
        game.deal(thisMany: 3)
        updateView()
    }
    
    @objc private func touchCard(sender: CardTapGestureRecognizer) {
        game.chooseCard(sender.card)
        updateView()
    }
    
    @objc private func rotateCards(recognizer: UIRotationGestureRecognizer) {
        if recognizer.state == .ended {
            game.shuffle()
            updateView()
        }
    }
    
    private func updateMatchedSetLabel() {
        if game.matchedSets > 0 {
            var matchedSetText = "\(game.matchedSets)"
            
            if game.matchedSets > 1 {
                matchedSetText += " Sets"
            } else {
                matchedSetText += " Set"
            }
            
            discardLabel.text = matchedSetText
        } else {
            discardLabel.text = ""
        }
    }

}
