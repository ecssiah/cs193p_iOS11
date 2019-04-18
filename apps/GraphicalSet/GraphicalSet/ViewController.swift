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
                target: self, action: #selector(rotateCards(sender:))
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
                cardView.frame = cardViewFrame.insetBy(
                    dx: CardView.inset, dy: CardView.inset
                )
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
                let card = game.cardsInPlay[index]
                
                let cardView = CardView(
                    frame: frame.insetBy(
                        dx: CardView.inset, dy: CardView.inset
                    )
                )
                
                cardView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cardView.layer.cornerRadius = 12
                cardView.layer.masksToBounds = true
                
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
                
                let cardTap = CardTapGestureRecognizer(
                    target: self, action: #selector(touchCard), card: card
                )
                cardView.addGestureRecognizer(cardTap)
                
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
        
        updateCardAreaView()
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
    private func touchCard(sender: CardTapGestureRecognizer) {
        game.chooseCard(sender.card)
        
        updateCardAreaView()
        updateView()
    }
    
    @objc
    private func rotateCards(sender: UIRotationGestureRecognizer) {
        game.shuffle()

        updateCardAreaView()
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
        
        let interval = TimeInterval.init(floatLiteral: 5)
        
        siriTimer = Timer.scheduledTimer(
            withTimeInterval: interval, repeats: false, block: siriChoice
        )
        
        updateView()
    }
    
    private func siriChoice(timer: Timer) {
        if !game.siriMove() {
            deal()
        }
        
        siriScoreLabel.text = "Siri: \(game.siriScore)"
        
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
        
        updateCardAreaView()
        updateView()
    }
    
    private func updateView() {
        playerScoreLabel.text = "Player: \(game.playerScore)"
        
        for index in game.cardsInPlay.indices {
            let card = game.cardsInPlay[index]
            let cardView = cardAreaView.subviews[index]
            
            if game.selectedCards.contains(card) {
                cardView.layer.borderWidth = 4
                cardView.layer.borderColor = #colorLiteral(red: 1, green: 0, blue: 0.4598447084, alpha: 1)
            } else {
                cardView.layer.borderWidth = 2
                cardView.layer.borderColor = #colorLiteral(red: 0.2341006696, green: 0.2327153981, blue: 0.2351695895, alpha: 1)
            }
        }
    }
}
