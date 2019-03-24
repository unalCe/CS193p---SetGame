//
//  Set.swift
//  SetGame
//
//  Created by Unal Celik on 20.03.2019.
//  Copyright © 2019 unalCe. All rights reserved.
//

import Foundation

class SetGame
{
    // MARK: - Variables
    private var upperCardLimit = 24
    private var lowerCardLimit = 12
    var score: Int
    var gameRange: Int {
        didSet {
            if gameRange > upperCardLimit { gameRange = upperCardLimit }
            if gameRange < lowerCardLimit { gameRange = lowerCardLimit }
            cardsOnTable += deck.getFirst(amountOf: gameRange - cardsOnTable.count)
        }
    }
    private(set) var deck = [Card]()
    private(set) var cardsOnTable: [Card]
    
    private var selectedCards: [Card] {
        get {
            return cardsOnTable.filter() { $0.isSelected }
        }
    }
    
    // MARK: - Functions
    /// Changes match cards with new ones from the deck, if the cards are not match then reset the selected cards to initial values.
    private func changeMatchedCards() {
        cardsOnTable.indices.forEach() {
            if cardsOnTable[$0].isMatched ?? false {
                cardsOnTable[$0] = deck.removeFirst()
            } else {
                cardsOnTable[$0].isSelected = false; cardsOnTable[$0].isMatched = nil
            }
        }
    }
    
/**
     Selects the card and checks if it's set or not. Changes the score accordingly.
     - parameter index: Index of selected card on the table
*/
    func selectCard(at index: Int) {
        if selectedCards.count == 3 { changeMatchedCards() }
        
        if !(cardsOnTable[index].isSelected) {
            cardsOnTable[index].isSelected = true
            
            if selectedCards.count == 3 {
                // Match ise match et
                
                if checkIfMatch() {
                    score += 60 / gameRange
                    cardsOnTable.indices.forEach() { if cardsOnTable[$0].isSelected { cardsOnTable[$0].isMatched = true } }
                } else {
                    score -= Int(0.3 * Double(gameRange))
                    cardsOnTable.indices.forEach() { if cardsOnTable[$0].isSelected { cardsOnTable[$0].isMatched = false } }
                }
            }
        } else {
            // deselect
            cardsOnTable[index].isSelected = false
            score -= 1
        }
    }
    
/**
     Returns true or false according to if all selected cards are set or not
     - returns: Bool - Set or not
 */
    private func checkIfMatch() -> Bool {
        var numbers = Set<Card.Number>()
        var shapes = Set<Card.Shape>()
        var colors = Set<Card.Color>()
        var fillings = Set<Card.Filling>()
        
        for card in selectedCards {
            numbers.insert(card.number); shapes.insert(card.shape); colors.insert(card.color); fillings.insert(card.filling)
        }
        let isSet = (numbers.count == 1 || numbers.count == 3) && (shapes.count == 1 || shapes.count == 3) && (colors.count == 1 || colors.count == 3) && (fillings.count == 1 || fillings.count == 3)
        
        return isSet
    }
    
/// Create the deck then shuffle. After that, fill up the table considering game range
    init() {
        deck = []
        gameRange = lowerCardLimit
        score = 0
        for number in Card.Number.allCases {
            for shape in Card.Shape.allCases {
                for color in Card.Color.allCases {
                    for filling in Card.Filling.allCases {
                        let card = Card(shape: shape, color: color, filling: filling, number: number)
                        deck += [card]
                    }
                }
            }
        }
        deck.shuffle()
        cardsOnTable = deck.getFirst(amountOf: gameRange)
    }
}
// MARK: -
extension Array where Element == Card {
    /// Returns given amount of elements from beginning of the array, and removes them.
    mutating func getFirst(amountOf: Int) -> [Element] {
        var returnCards = [Element]()
        for _ in 0..<amountOf {
            returnCards.append(self.removeFirst())
        }
        return returnCards
    }
}

