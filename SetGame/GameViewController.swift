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
    
    @IBAction func dealThreeMoreCards(_ sender: UIButton) {
        game.gameRange += 3
        updateViews()
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
    }
    
    @IBAction func chooseCard(_ sender: UIButton) {
        if let cardNo = cardCollection.index(of: sender) {
            game.selectCard(at: cardNo)
            updateViews()
        } else {
            print("There is no such a card on the table.")
        }
    }
    
    // MARK: - Variables
    let game = SetGame()
    let defaultBorderWidth: CGFloat = 0.5
    let defaultBorderColor = UIColor.darkGray.cgColor
    let selectedBorderWidth: CGFloat = 3
    let selectedBorderColor = UIColor.green.cgColor
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(game.deck.description)
        updateViews()
    }
    
    // MARK: -
    private func updateViews() {
        scoreLabel.text = "Score: \(game.score)"
        for index in 0..<game.gameRange {
            let button = cardCollection[index]
            let card = game.cardsOnTable[index]
            
            button.setAttributedTitle(attributedString(for: card), for: .normal)
            button.layer.cornerRadius = 6
            
            if card.isSelected {
                button.layer.borderWidth = selectedBorderWidth
                button.layer.borderColor = selectedBorderColor
            } else {
                button.layer.borderWidth = defaultBorderWidth
                button.layer.borderColor = defaultBorderColor
            }
        }
    }

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
