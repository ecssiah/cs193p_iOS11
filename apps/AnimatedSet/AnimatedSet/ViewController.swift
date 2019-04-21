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
    weak var deckView: UIView!
    
    @IBOutlet
    weak var discardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCardViews()
    }

    override func viewDidLayoutSubviews() {
        
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
        for card in game.playedCards {
            let cardViews = cardAreaView.subviews.compactMap { $0 as? CardView }

            if let cardView = cardViews.first(where: { $0.card == card }) {
                if game.selectedCards.contains(card) {
                    cardView.selected = true
                } else {
                    cardView.selected = false
                }
            }
        }
    }
    
    func setupCardViews() {
        grid.frame = cardAreaView.bounds
        grid.cellCount = game.playedCards.count
        
        let initialFrame = cardAreaView.convert(deckView.frame, from: deckView)
        
        for card in game.deck {
            let cardView = CardView(frame: initialFrame)
            cardView.card = card
            cardView.backgroundColor = UIColor.clear
            
            cardAreaView.addSubview(cardView)
        }

        for index in game.playedCards.indices {
            if let frame = grid[index] {
                let card = game.playedCards[index]
                let cardViews = cardAreaView.subviews.compactMap { $0 as? CardView }
                
                if let cardView = cardViews.first(where: { $0.card == card }) {
                    let cardTap = CardTapGestureRecognizer(
                        target: self, action: #selector(touchCard), card: card
                    )
                    cardView.addGestureRecognizer(cardTap)
                    
                    Timer.scheduledTimer(
                        withTimeInterval: 0.4 * Double(index) + 1.0,
                        repeats: false,
                        block: { timer in
                            UIView.transition(
                                with: cardView,
                                duration: 2.0,
                                options: [.transitionFlipFromTop],
                                animations: {
                                    cardView.faceUp = true
                                }
                            )
                        }
                    )

                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 2.0,
                        delay: 0.4 * Double(index) + 1.0,
                        options: [],
                        animations: {
                            cardView.frame = frame.insetBy(dx: CardView.inset, dy: CardView.inset)
                        },
                        completion: { position in

                        }
                    )
                }
            }
        }
    }
}
