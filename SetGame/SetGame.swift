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
    var upperCardLimit = 24
    var lowerCardLimit = 12
    var score = 0
    var gameRange = 12 {
        didSet {
            if gameRange > upperCardLimit { gameRange = upperCardLimit }
            if gameRange < lowerCardLimit { gameRange = lowerCardLimit }
            cardsOnTable += deck.getFirst(amountOf: gameRange - cardsOnTable.count)
        }
    }
    private(set) var deck = [Card]()
    private(set) var cardsOnTable: [Card]
    
    private var selectedCards: [Card] { get { return cardsOnTable.filter() { $0.isSelected } } }
    
 //   private var matchedCards: [Card] { get { return deck.filter() { $0.isMatched } } }
    
    private var selectedCount: Int { get { return selectedCards.filter(){ !$0.isMatched } .count } }
    
    func selectCard(at index: Int) {
        assert(deck.indices.contains(index), "There is no such index in deck.")
        
        if selectedCount == 3 {
            // Match ise match et
            
            if checkIfMatch() {
                print("BUMMM BE YERAG")
                score += 48 / gameRange
                print("+ \(48/gameRange) puan")
            } else {
                score -= Int(0.3 * Double(gameRange))
                print("- \(Int(0.41 * Double(gameRange))) puan")
            }
            
            // Clear selected cards.
            cardsOnTable = cardsOnTable.indices.map() { cardsOnTable[$0].isSelected = false; return cardsOnTable[$0] }
        }
        
        if !(cardsOnTable[index].isSelected) {
            cardsOnTable[index].isSelected = true
            print("----> sayim ", selectedCount)
            
        } else if selectedCount < 3 {
            // deselect
            cardsOnTable[index].isSelected = false
            score -= 1
            print("\(cardsOnTable[index]) seçilmekten vazgeçildi.")
        }
    }
    
    /// Returns true or false according to if all selected cards are matching
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
    
    init() {
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

