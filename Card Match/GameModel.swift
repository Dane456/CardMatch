//
//  GameModel.swift
//  Card Match
//
//  Created by Dane Jordan on 1/18/15.
//  Copyright (c) 2015 Dane Jordan. All rights reserved.
//

import UIKit

class GameModel: NSObject {
    
    func getCards() -> [Card] {
        
        var generatedCards:[Card] = [Card]()
        
        
        
        for i in 0...7{
            
            //Generate a random number
            
            var randNum:Int = Int(arc4random_uniform(13))
            
            //Create a new card object
            var firstCard:Card = Card()
            firstCard.cardValue = randNum
            
            //Create second card object
            
            var secondCard:Card = Card()
            secondCard.cardValue = randNum
            
            //Place card objects into the array
            generatedCards += [firstCard, secondCard]
            
        }
        
        // Randomize the cards
        for index in 0...(generatedCards.count - 1){
            
            //Current card
            var currentCard:Card = generatedCards[index]
            
            //Randomly choose another index
            var randomIndex:Int = Int(arc4random_uniform(16))
            
            //Swap objects at the two indexes
            generatedCards[index] =  generatedCards[randomIndex]
            generatedCards[randomIndex] = currentCard
            
            
        }
        
        
        return generatedCards
    }
   
}
