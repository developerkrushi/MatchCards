//
//  ViewController.swift
//  MatchCards
//
//  Created by Krushivardhan Reddy on 01/05/21.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timerLabel: UILabel!
    
    let model = CardModel()
    var cardsArray = [Card]()
    var timer:Timer?
    var milliseconds:Int = 45 * 1000
    var firstFlippedCardindex:IndexPath?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardsArray = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Initialize the timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    // MARK: - Timer methods
    
    @objc func timerFired() {
        // Decrement the counter
        milliseconds -= 1
        
        // Update the label
        let seconds = milliseconds/1000
        timerLabel.text = String(format: "Time remaining: %d", seconds)
        timerLabel.textColor = UIColor.black
        
        //Stop the timer if reached zero
        if milliseconds == 0 {
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            
            // TODO: check if user has cleared all pairs
            checkForGameEnd()
        }
        
        
    }

    // MARK: - Collection Delegates and Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //get a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        
        //return the cell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // configure the state of the cell based on the properties of the card
        let cardCell = cell as? CardCollectionViewCell
        
        //confifure the cell
        cardCell?.configureCell(card: cardsArray[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        if cell?.card?.isCardFlipped == false && cell?.card?.isCardMatched == false {
            
            cell?.flipUp()
            
            if firstFlippedCardindex == nil {
                
                // first card is flipped
                firstFlippedCardindex = indexPath
            }
            else {
                
                // second card is flipped
                
                // run the match logic
                checkForMatch(indexPath)
                firstFlippedCardindex = nil
            }
            
            
        }
        

        
    }
    
    // MARK: - Game Logic methods
    
    func checkForMatch(_ secondFlippedCardindex:IndexPath) {
        
        // Get the card indexes for both cards
        let cardOne = cardsArray[firstFlippedCardindex!.row]
        let cardTwo = cardsArray[secondFlippedCardindex.row]
        
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardindex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardindex) as? CardCollectionViewCell
        
        if cardOne.imageName == cardTwo.imageName {
            
            // Set the m atch status and remove them
            cardOne.isCardMatched = true
            cardTwo.isCardMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // check if its the last pair
            
            checkForGameEnd()
        }
        else {
            // Flip them back over
            
            cardOne.isCardFlipped = false
            cardTwo.isCardFlipped = false
            
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
        }
    }
    
    func checkForGameEnd() {
        
        var hasWon = true
        
        for card in cardsArray {
            
            if card.isCardMatched == false {
                hasWon = false
                
                break
            }
        }
        
        if hasWon {
            //User has Won. Show Alert
            
            showAlert(title: "Congratulations", message: "You've won the game!")
        }
        else {
            
            //user has not won. check if there is time left
            if milliseconds <= 0 {
                showAlert(title: "Time's Up", message: "Sorry, better luck next time")
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: resetGame)
    }


// MARK: - Reset Game
    
    func resetGame() {
        
        for card in cardsArray {
            card.isCardMatched = false
            card.isCardFlipped = false
        }
        
        viewDidLoad()
    }

}
