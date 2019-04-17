//
//  ViewController.swift
//  GraphicalSet
//
//  Created by Michael Chapman on 4/12/19.
//  Copyright © 2019 Gauge Structures. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var siriActive = false
    private var siriTimer = Timer()
    
    private var game = SetGame()
    private var grid = Grid(layout: Grid.Layout.aspectRatio(CGFloat(6.0/8.0)))

    @IBOutlet
    weak var playerScoreLabel: UILabel!
    @IBOutlet
    weak var siriScoreLabel: UILabel!
    @IBOutlet
    weak var siriAvatarButton: UIButton!
    
    @IBOutlet
    weak var cardAreaView: UIView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(
                target: self, action: #selector(deal)
            )
            swipe.direction = .down
            cardAreaView.addGestureRecognizer(swipe)
            
            let rotate = UIRotationGestureRecognizer(
                target: self, action: #selector(rotateCards(recognizedBy:))
            )
            cardAreaView.addGestureRecognizer(rotate)
        }
    }
    
    @IBOutlet
    weak var newGameButton: UIButton! {
        didSet {
            newGameButton.layer.cornerRadius = 12
            newGameButton.layer.borderWidth = 2
            newGameButton.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCardAreaView()
        updateView()
    }

    override func viewDidLayoutSubviews() {
        grid.frame = cardAreaView.bounds
        
        for index in cardAreaView.subviews.indices {
            let cardView = cardAreaView.subviews[index]
            
            if let cardViewFrame = grid[index] {
                cardView.frame = cardViewFrame
            }
        }
    }
    
    func updateCardAreaView() {
        for view in cardAreaView.subviews {
            view.removeFromSuperview()
        }
        
        grid.frame = cardAreaView.bounds
        grid.cellCount = game.cardsInPlay.count
        
        for index in game.cardsInPlay.indices {
            if let frame = grid[index] {
                let cardView = CardView(frame: frame)
                cardView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cardView.layer.borderWidth = 1
                cardView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                
                let card = game.cardsInPlay[index]
                
                switch card.feature1 {
                case Card.Variant.v1: cardView.shape = CardView.Shape.diamond
                case Card.Variant.v2: cardView.shape = CardView.Shape.oval
                case Card.Variant.v3: cardView.shape = CardView.Shape.squiggle
                }
                
                switch card.feature2 {
                case Card.Variant.v1: cardView.style = CardView.Style.solid
                case Card.Variant.v2: cardView.style = CardView.Style.striped
                case Card.Variant.v3: cardView.style = CardView.Style.unfilled
                }
                
                switch card.feature3 {
                case Card.Variant.v1: cardView.color = CardView.Color.green
                case Card.Variant.v2: cardView.color = CardView.Color.purple
                case Card.Variant.v3: cardView.color = CardView.Color.red
                }
                
                switch card.feature4 {
                case Card.Variant.v1: cardView.number = CardView.Number.one
                case Card.Variant.v2: cardView.number = CardView.Number.two
                case Card.Variant.v3: cardView.number = CardView.Number.three
                }
                
                cardAreaView.addSubview(cardView)
            }
        }
    }
    
    @IBAction
    private func newGame(_ sender: UIButton) {
        game.newGame()
        
        siriActive = false
        siriTimer.invalidate()
        siriAvatarButton.setTitle("😴", for: UIControl.State.normal)
        siriScoreLabel.text = "Siri: \(game.siriScore)"
        
        updateView()
    }
    
    @IBAction
    private func siriAvatarAction(_ sender: UIButton) {
        if siriActive {
            siriActive = false
            siriTimer.invalidate()
            siriAvatarButton.setTitle("😴", for: UIControl.State.normal)
        } else {
            siriActive = true
            startSiri()
        }
    }
    
    @objc
    private func deal() {
        game.deal(thisMany: 3)
        updateCardAreaView()
        updateView()
    }
    
    @objc
    private func rotateCards(
        recognizedBy recognizer: UIRotationGestureRecognizer
    ) {

    }
    
    private func startSiri() {
        let interval = TimeInterval.init(Double.random(in: 5...85))

        siriAvatarButton.setTitle("🤔", for: UIControl.State.normal)
        
        siriTimer = Timer.scheduledTimer(
            withTimeInterval: interval, repeats: false, block: siriPreChoice
        )
    }
    
    private func siriPreChoice(timer: Timer) {        
        siriAvatarButton.setTitle("😏", for: UIControl.State.normal)
        siriScoreLabel.text = "Siri: \(game.siriScore)"
        
        updateView()
        
        let interval = TimeInterval.init(floatLiteral: 5)
        
        siriTimer = Timer.scheduledTimer(
            withTimeInterval: interval, repeats: false, block: siriChoice
        )
    }
    
    private func siriChoice(timer: Timer) {
        game.siriMove()
        
        if (game.over) {
            if game.siriScore > game.playerScore {
                siriAvatarButton.setTitle("😃", for: UIControl.State.normal)
            } else if game.siriScore < game.playerScore {
                siriAvatarButton.setTitle("😔", for: UIControl.State.normal)
            } else {
                siriAvatarButton.setTitle("😕", for: UIControl.State.normal)
            }
        } else {
            startSiri()
        }
        
        siriScoreLabel.text = "Siri: \(game.siriScore)"
        
//        cleanupBoard()
        updateView()
    }
    
    private func updateView() {
        playerScoreLabel.text = "Player: \(game.playerScore)"
        
        if game.over || game.full || game.deckEmpty {
            // TODO: disable deal
        } else {
            // TODO: enable deal
        }
        
//        for index in cardSlots.indices {
//            let slot = cardSlots[index]
//            let button = cardButtons[index]
//
//            if slot == nil {
//                button.layer.borderWidth = 0.0
//                button.setTitle(nil, for: UIControl.State.normal)
//                button.setAttributedTitle(nil, for: UIControl.State.normal)
//                button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
//            } else {
//                let card = slot!
//
//                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//
//                if game.selectedCards.contains(card) {
//                    button.layer.borderWidth = 4.0
//                    button.layer.borderColor = #colorLiteral(red: 0, green: 0.9344006181, blue: 0.8458675742, alpha: 1)
//                } else {
//                    button.layer.borderWidth = 0.0
//                }
//
//                var strokeWidth: Double
//                var cardColor: UIColor
//                var foregroundColor: UIColor
//
//                if card.color == 0 {
//                    cardColor = #colorLiteral(red: 0.3988213539, green: 0.2490597665, blue: 0.7633544207, alpha: 1)
//                } else if card.color == 1 {
//                    cardColor = #colorLiteral(red: 0.7223100066, green: 0.1986979246, blue: 0.4815690517, alpha: 1)
//                } else {
//                    cardColor = #colorLiteral(red: 0, green: 0.5941582322, blue: 0.3905805945, alpha: 1)
//                }
//
//                if card.style == 0 {
//                    strokeWidth = -1
//                    foregroundColor = cardColor.withAlphaComponent(0.40)
//                } else if card.style == 1 {
//                    strokeWidth = -1
//                    foregroundColor = cardColor.withAlphaComponent(1.00)
//                } else {
//                    strokeWidth = 6
//                    foregroundColor = cardColor.withAlphaComponent(0.00)
//                }
//
//                let attributes: [NSAttributedString.Key : Any] = [
//                    .strokeColor: cardColor,
//                    .foregroundColor: foregroundColor,
//                    .strokeWidth: strokeWidth,
//                    .font: UIFont.systemFont(ofSize: 26),
//                ]
//
//                var shapeString = ""
//                for _ in 1...card.number {
//                    shapeString += shapes[card.shape]
//                }
//
//                button.setAttributedTitle(
//                    NSAttributedString(
//                        string: shapeString, attributes: attributes
//                    ),
//                    for: UIControl.State.normal
//                )
//            }
//        }
    }
    
    
}

