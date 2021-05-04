//
//  CardModel.swift
//  MatchCards
//
//  Created by Krushivardhan Reddy on 01/05/21.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        
        var generatedCards = [Card]()
        var randomNumberArray = [Int]()
        
        while generatedCards.count < 16{
            
            let randomNumber = Int.random(in: 1...13)
            
            let card1 = Card()
            let card2 = Card()
            
            
            if !(randomNumberArray.contains(randomNumber)) {
                card1.imageName = "card\(randomNumber)"
                card2.imageName = "card\(randomNumber)"
                generatedCards += [card1, card2]
                randomNumberArray.append(randomNumber)
            }
            
        }

        generatedCards.shuffle()
        return generatedCards
    }
}
