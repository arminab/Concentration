//
//  ViewController.swift
//  Concentration
//
//  Created by Armin Haj Aboutalebi on 12/17/17.
//  Copyright © 2017 edu.utsa.armin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    private(set) var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    private(set) var scoreCount = 0 {
        didSet {
            scoreCountLabel.text = "Score: \(scoreCount)"
        }
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private weak var scoreCountLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in buttons")
        }
        flipCount = game.flips
        scoreCount = game.score
        
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
    
    private var emojiChoicesWithThemes = [
        "Animals": ["🐶", "🐷", "🐔", "🐥", "🐝", "🦋", "🦀", "🦈"],
        "Faces": ["😀", "😋", "😊", "🙃", "🤩", "😰", "💀", "🤠"],
        "Sports": ["⚽️", "🏒", "🏑", "🥊", "🏄‍♀️", "🏅", "🚴‍♀️", "🏓"],
        "Foods": ["🍏", "🥦", "🍑", "🥕", "🍔", "🍕", "🍚", "🌭"],
        "Machines": ["🚒", "🏍", "🚌", "🚑", "🚔", "✈️", "🚀", "🛰"],
        "Objects": ["⌚️", "💻", "🎥", "📱", "📀", "⌛️", "📡", "🔦"]]
    
    private var emojiChoices = [String]()
    
    override func viewDidLoad() {
        emojiChoices = Array(emojiChoicesWithThemes.values)[emojiChoicesWithThemes.count.arc4random]
    }
    
    private var emoji = [Card:String]()

    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            emoji[card] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }
        
        return emoji[card] ?? "?"
    }
    
    
    @IBAction private func newGame(_ sender: UIButton) {
        flipCount = 0
        scoreCount = 0
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        updateViewFromModel()
        emojiChoices = Array(emojiChoicesWithThemes.values)[emojiChoicesWithThemes.count.arc4random]
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return Int(arc4random_uniform(UInt32(-self)))
        } else {
            return 0
        }
    }
}
