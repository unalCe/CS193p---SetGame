//
//  ViewController.swift
//  SetGame
//
//  Created by Unal Celik on 20.03.2019.
//  Copyright © 2019 unalCe. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet var cardCollection: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var dealThreeMoreCardsButton: UIButton!
    
    @IBAction func dealThreeMoreCards(_ sender: UIButton) {
        // Works nice. Looks meh.
        if game.didThreeCardSelected {
            game.changeMatchedCards()
            initializeDeckView()
        } else {
            game.gameRange += 3
        }
        updateViews()
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
        game = SetGame()
        initializeDeckView()
        updateViews()
    }
    
    @IBAction func chooseCard(_ sender: UIButton) {
        if let cardNo = cardCollection.index(of: sender) {
            game.selectCard(at: cardNo)
            initializeDeckView()
            updateViews()
        } else {
            print("There is no such a card on the table.")
        }
    }
    
    // MARK: - Variables
    var game = SetGame()
    let defaultBorderWidth: CGFloat = 0.5
    let defaultBorderColor = UIColor.darkGray.cgColor
    let selectedBorderWidth: CGFloat = 3
    var selectedBorderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1).cgColor
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeDeckView()
        updateViews()
    }
    
    // MARK: - Functions
    /// Remove all cards on the table
    private func initializeDeckView() {
        cardCollection.forEach() { $0.setAttributedTitle(nil, for: .normal); $0.layer.borderWidth = 0; $0.alpha = 0.2; $0.layer.cornerRadius = 6; $0.isEnabled = false }
    }
    
    /// Update the cards on the table
    private func updateViews() {
        scoreLabel.text = "Score: \(game.score)"
        dealThreeMoreCardsButton.isEnabled = game.didThreeCardSelected || (game.gameRange < 24 && game.deck.count > 2)
        
        for index in 0..<game.gameRange {
            let button = cardCollection[index]
            let card = game.cardsOnTable[index]
            
            if game.matchedCardsThatWillBeRemoved.contains(card) {
                // skip drawing this one
                continue
            }
            
            button.isEnabled = true; button.alpha = 1
            button.setAttributedTitle(attributedString(for: card), for: .normal)
            
            if let cardMatch = card.isMatched {
                selectedBorderColor = cardMatch ? #colorLiteral(red: 0, green: 1, blue: 0.08472456465, alpha: 1).cgColor : #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1).cgColor
            } else {
                selectedBorderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).cgColor
            }
            
            if card.isSelected {
                button.layer.borderWidth = selectedBorderWidth
                button.layer.borderColor = selectedBorderColor
            } else {
                button.layer.borderWidth = defaultBorderWidth
                button.layer.borderColor = defaultBorderColor
            }
        }
    }

/**
     Returns an attributed string for a given card
     - parameter card: Card
     - returns: Attributed string
 */
    private func attributedString(for card: Card) -> NSAttributedString {
        var attributes = [NSAttributedString.Key : Any]()
        var cardColor = UIColor()
        var cardString = ""
        let font = UIFont.preferredFont(forTextStyle: .body).withSize(25)
        
        attributes = [NSAttributedString.Key.font: font]
        
        switch card.shape {
        case .round: cardString = "●"
        case .square: cardString = "■"
        case .triangle: cardString = "▲"
        }
        
        switch card.color {
        case .red: cardColor = .red
        case .blue: cardColor = .blue
        case .green: cardColor = .green
        }
        
        switch card.filling {
        case .outlined:
            attributes[.strokeWidth] = 12
            fallthrough
        case .filled:
            attributes[.foregroundColor] = cardColor
        case .striped:
            attributes[.foregroundColor] = cardColor.withAlphaComponent(0.3)
        }
        
        // Number of characters
        cardString = String(repeating: cardString, count: card.number.rawValue)
        return NSAttributedString(string: cardString, attributes: attributes)
    }
}
