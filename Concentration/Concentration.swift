//
//  Concentration.swift
//  Concentration
//
//  Created by Armin Haj Aboutalebi on 12/29/17.
//  Copyright © 2017 edu.utsa.armin. All rights reserved.
//

import Foundation

struct Concentration
{
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            let faceUpCardIndices = cards.indices.filter { cards[$0].isFaceUp }
            return faceUpCardIndices.count == 1 ? faceUpCardIndices.first : nil
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    var score = 0
    
    var flips = 0
    
    mutating func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            flips += 1
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                }
                cards[index].isFaceUp = true
                
                if (cards[matchIndex].isSeen && !cards[matchIndex].isMatched) {
                    score -= 1
                }
                if (cards[index].isSeen && !cards[index].isMatched) {
                    score -= 1
                }
                cards[index].isSeen = true
                cards[matchIndex].isSeen = true
            } else {
                // either no cards or 2 cards are face up
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        
        // Shuffle the cards
        var shuffled = [Card]();
        for _ in 0..<cards.count
        {
            let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
            shuffled += [cards.remove(at: randomIndex)]
        }
        cards = shuffled
    }
}

