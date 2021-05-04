//
//  CardCollectionViewCell.swift
//  MatchCards
//
//  Created by Krushivardhan Reddy on 02/05/21.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func configureCell(card:Card) {
        
        self.card = card
        
        // set the front image view 
        frontImageView.image = UIImage(named: card.imageName)
        
        if card.isCardMatched == true {
            frontImageView.alpha = 0
            backImageView.alpha = 0
            return
        }
        else {
            frontImageView.alpha = 1
            backImageView.alpha = 1
        }
        
        if card.isCardFlipped == false {
            
            flipDown(speed : 0, delay: 0)
        }
        
        else {
            
            flipUp(speed : 0)
        }
    }
    
    func flipUp(speed:TimeInterval = 0.3) {
        
        UIView.transition(from: backImageView, to: frontImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        
        card?.isCardFlipped = true
    }
    
    func flipDown(speed:TimeInterval = 0.3, delay:TimeInterval = 0.5) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromRight], completion: nil)
        }
        
        card?.isCardFlipped = false
    }
    
    func remove() {
        
        //fade out back image
        backImageView.alpha = 0
        
        //fade out front image view with animation
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
    }
}
