//
//  ViewController.swift
//  GraphicalSet
//
//  Created by Michael Chapman on 4/12/19.
//  Copyright © 2019 Gauge Structures. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let numSlots = 24
    private let shapes = ["▲", "●", "■"]
    
    private var siriTimer = Timer()
    private var siriActive = false
    
    private lazy var cardSlots = [Card?]()
    
    private var game = SetGame()
    
    @IBOutlet
    weak var playerScoreLabel: UILabel!
    @IBOutlet
    weak var siriScoreLabel: UILabel!
    @IBOutlet
    weak var siriAvatarButton: UIButton!
    
    @IBOutlet
    private var cardButtons: [UIButton]! {
        didSet {
            for index in cardButtons.indices {
                cardButtons[index].layer.cornerRadius = 12
                cardButtons[index].titleLabel?.textAlignment = NSTextAlignment.center
                cardButtons[index].titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            }
        }
    }
    
    @IBOutlet
    private weak var dealButton: UIButton! {
        didSet {
            dealButton.layer.cornerRadius = 12
            dealButton.layer.borderWidth = 2
            dealButton.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            dealButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControl.State.normal)
            dealButton.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: UIControl.State.disabled)
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
    
    @IBAction
    private func deal(_ sender: UIButton) {
        game.calculateDealingPenalty()
        
        for _ in 1...3 {
            let card = game.deal()
            
            for index in cardSlots.indices {
                let slot = cardSlots[index]
                
                if slot == nil {
                    cardSlots[index] = card
                    break
                }
            }
        }
        
        updateView()
    }
    
    @IBAction
    private func newGame(_ sender: UIButton) {
        game.newGame()
        
        siriActive = false
        siriTimer.invalidate()
        siriAvatarButton.setTitle("😴", for: UIControl.State.normal)
        siriScoreLabel.text = "Siri: \(game.siriScore)"
        
        setBoard()
        updateView()
    }
    
    @IBAction
    private func touchCard(_ sender: UIButton) {
        if let index = cardButtons.firstIndex(of: sender) {
            if let slot = cardSlots[index] {
                game.chooseCard(card: slot)
                cleanupBoard()
            }
        } else {
            print("card is not in collection")
        }
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
        
        cleanupBoard()
        updateView()
    }

    
    
    private func setBoard() {
        cardSlots.removeAll()
        
        for card in game.cardsInPlay {
            cardSlots.append(card)
        }
        
        while cardSlots.count < numSlots {
            cardSlots.append(nil)
        }
    }
    
    private func cleanupBoard() {
        for index in cardSlots.indices {
            if let card = cardSlots[index], !game.cardsInPlay.contains(card) {
                cardSlots[index] = nil
            }
        }
        
        updateView()
    }
    
    private func updateView() {
        playerScoreLabel.text = "Player: \(game.playerScore)"
        
        if game.over || game.full || game.deckEmpty {
            dealButton.isEnabled = false
        } else {
            dealButton.isEnabled = true
        }
        
        for index in cardSlots.indices {
            let slot = cardSlots[index]
            let button = cardButtons[index]
                        
            if slot == nil {
                button.layer.borderWidth = 0.0
                button.setTitle(nil, for: UIControl.State.normal)
                button.setAttributedTitle(nil, for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            } else {
                let card = slot!
                
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                
                if game.selectedCards.contains(card) {
                    button.layer.borderWidth = 4.0
                    button.layer.borderColor = #colorLiteral(red: 0, green: 0.9344006181, blue: 0.8458675742, alpha: 1)
                } else {
                    button.layer.borderWidth = 0.0
                }
                
                var strokeWidth: Double
                var cardColor: UIColor
                var foregroundColor: UIColor
                
                if card.color == 0 {
                    cardColor = #colorLiteral(red: 0.3988213539, green: 0.2490597665, blue: 0.7633544207, alpha: 1)
                } else if card.color == 1 {
                    cardColor = #colorLiteral(red: 0.7223100066, green: 0.1986979246, blue: 0.4815690517, alpha: 1)
                } else {
                    cardColor = #colorLiteral(red: 0, green: 0.5941582322, blue: 0.3905805945, alpha: 1)
                }
                
                if card.style == 0 {
                    strokeWidth = -1
                    foregroundColor = cardColor.withAlphaComponent(0.40)
                } else if card.style == 1 {
                    strokeWidth = -1
                    foregroundColor = cardColor.withAlphaComponent(1.00)
                } else {
                    strokeWidth = 6
                    foregroundColor = cardColor.withAlphaComponent(0.00)
                }
                
                let attributes: [NSAttributedString.Key : Any] = [
                    .strokeColor: cardColor,
                    .foregroundColor: foregroundColor,
                    .strokeWidth: strokeWidth,
                    .font: UIFont.systemFont(ofSize: 26),
                ]
                
                var shapeString = ""
                for _ in 1...card.number {
                    shapeString += shapes[card.shape]
                }
                
                button.setAttributedTitle(
                    NSAttributedString(
                        string: shapeString, attributes: attributes
                    ),
                    for: UIControl.State.normal
                )
            }
        }
    }
    
    override func viewDidLoad() {
        setBoard()
        updateView()
    }
}

