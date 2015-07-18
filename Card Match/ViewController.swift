//
//  ViewController.swift
//  Card Match
//
//  Created by Dane Jordan on 1/1/15.
//  Copyright (c) 2015 Dane Jordan. All rights reserved.
//

import AVFoundation
import UIKit

class ViewController: UIViewController {
    
    
    //Storyboard IBOutlet Props
    @IBOutlet weak var cardScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var countdownLabel: UILabel!
    
    var gameModel: GameModel = GameModel()
    var cards:[Card] = [Card]()
    var revealedCard:Card?
    
    //Timer Props
    var timer:NSTimer!
    var countdown:Int = 20
    
    //Audio props
    var correctSoundPlayer:AVAudioPlayer?
    var wrongSoundPlayer:AVAudioPlayer?
    var shuffleSoundPlayer:AVAudioPlayer?
    var flipSoundPlayer:AVAudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Initialize the audio players
        var correctSoundUrl:NSURL? = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("dingcorrect", ofType: "wav")!)
        if (correctSoundUrl != nil){
            self.correctSoundPlayer = AVAudioPlayer(contentsOfURL: correctSoundUrl!, error: nil)
        }
        
        var wrongSoundUrl:NSURL? = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("dingwrong", ofType: "wav")!)
        if (wrongSoundUrl != nil){
            self.wrongSoundPlayer = AVAudioPlayer(contentsOfURL: wrongSoundUrl!, error: nil)
        }
        
        var shuffleSoundUrl:NSURL? = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("shuffle", ofType: "wav")!)
        if (correctSoundUrl != nil){
            self.shuffleSoundPlayer = AVAudioPlayer(contentsOfURL: shuffleSoundUrl!, error: nil)
        }
        
        var flipSoundUrl:NSURL? = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cardflip", ofType: "wav")!)
        if (flipSoundUrl != nil){
            self.flipSoundPlayer = AVAudioPlayer(contentsOfURL: flipSoundUrl!, error: nil)
        }
        
        
        
        // Get the cards from the game model
        
        self.cards = self.gameModel.getCards()
        
        //Layout cards
        self.layoutCards()
        
        //Play Shuffle sound
        if (self.shuffleSoundPlayer != nil) {
           self.shuffleSoundPlayer?.play()
        }
        
        
        
        //Start the timer
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("timerUpdate"), userInfo: nil, repeats: true)
            
            NSTimer(timeInterval: 1, target: self, selector: Selector("timerUpdate"), userInfo: nil, repeats: true)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func timerUpdate() {
        
        //Decrements counter
        countdown--
        
        //Update countdown label
        self.countdownLabel.text = String(countdown)
        
        //Game over conditions
        if (countdown == 0) {
            
            //Stop the timer
            self.timer.invalidate()
            
            //Check if an unmatched card exists
            var allCardsMatched:Bool = true
            
            for card in self.cards {
                  
                if (!card.isDone){
                    
                    allCardsMatched = false
                    break
                    //Display losing message
                    
                }
                
            }
            
            var alertText:String = ""
            if (allCardsMatched) {
                
                //win message
                alertText = "GOOD SHIT BITCH"
            }
            else{
                
                alertText = "HAHAHA BITCH"
            }
            
            var alert:UIAlertController = UIAlertController(title: "BOOM", message: alertText, preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "FUCK YOU", style: UIAlertActionStyle.Cancel, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        }
    }

    func layoutCards() {
     
        var columnCounter:Int = 0
        var rowCounter:Int = 0
    
        // Loop through each card in the array
        for index in 0...self.cards.count-1 {
           
            // Place the card in the view and turn off translate autoresizing mask
            var thisCard:Card = self.cards[index]
            thisCard.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.contentView.addSubview(thisCard)
            
            var tapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("cardTapped:"))
            thisCard.addGestureRecognizer(tapGestureRecognizer)
            
            
            // Set the height and width constraints
            var heightConstraint:NSLayoutConstraint=NSLayoutConstraint(item: thisCard, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 170)
            
            var widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: thisCard, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 120)
            
            thisCard.addConstraints([heightConstraint, widthConstraint])
            
            // set the horizontal position
            if (columnCounter > 0) {
                //Card is not in the first column
                var cardOnTheLeft:Card = self.cards[index-1]
                
                var leftMarginConstraint:NSLayoutConstraint = NSLayoutConstraint(item: thisCard, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: cardOnTheLeft, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 5)
                
                //Add constraint
                self.contentView.addConstraint(leftMarginConstraint)
            }
                else {
                //Card is in the first column
                var leftMarginConstraint:NSLayoutConstraint = NSLayoutConstraint(item: thisCard, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
            
            
                //Add constraint
                self.contentView.addConstraint(leftMarginConstraint)
            }
            
            // set the vertical position
            if (rowCounter > 0) {
                
                //Card is not in the first row
                var cardOnTop:Card = self.cards[index - 4]
                
                var topMarginConstraint:NSLayoutConstraint = NSLayoutConstraint(item: thisCard, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: cardOnTop , attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5)
                
                //Add constraint
                self.contentView.addConstraint(topMarginConstraint)
                
            }
            else {
                    
                //Card is in the first row
                var topMarginConstraint:NSLayoutConstraint = NSLayoutConstraint(item: thisCard, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 10)
            
                
                //Add constraint
                self.contentView.addConstraint(topMarginConstraint)
            }
            // If the column reaches the fifth column, reset it and increment the row counter
            columnCounter++
            if (columnCounter >= 4) {
                columnCounter = 0
                rowCounter++
            }
            
        }// end for loop
        
        //Add height constraint to the content view so the scroll view knows how much to scroll
        var contentViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.contentView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.cards[0], attribute: NSLayoutAttribute.Height, multiplier: 4, constant: 35 )
        
        self.contentView.addConstraint(contentViewHeightConstraint)
        
    }// end layout function
    
    func cardTapped(recognizer:UITapGestureRecognizer) {
        
        //If countdown is 0, exit
        
        if(self.countdown == 0){
            
           return
        }
        //get the card that was tapped
        
        var cardThatWasTapped:Card = recognizer.view as Card
        
        //Is this a facedown card
        if (cardThatWasTapped.isFlippled == false) {
            
            //Play card flip sound
            if (self.flipSoundPlayer != nil){
                self.flipSoundPlayer?.play()
            }
            
            //Is this the first card being flipped?
            if(self.revealedCard == nil) {
                
                //This is the first card being flipped
                //flip down all the cards
                //self.flipDownAllCards()
                
                
                //Flip up the card
                cardThatWasTapped.flipUp()
                
                //Set the revealed card
                self.revealedCard = cardThatWasTapped
                
            }
            else{
                // This is the second card being flipped
              
                //Flip the card
                cardThatWasTapped.flipUp()
                
                // Check if the cards are the same
                if (self.revealedCard?.cardValue == cardThatWasTapped.cardValue) {
                    
                    //It's a match
                    
                    //Play correct sound
                    if (self.correctSoundPlayer != nil){
                        self.correctSoundPlayer?.play()
                    }
                    
                    //remove both cards
                    self.revealedCard?.isDone = true
                    cardThatWasTapped.isDone = true
                    
                    //Reset the revealed card
                    self.revealedCard = nil
                    
                }
                //Cards are different
                else {
                    
                    //play wrong sound
                    if (self.wrongSoundPlayer != nil){
                        self.wrongSoundPlayer?.play()
                    }
                    
                    //Flip down both cards
                    var timer1 = NSTimer.scheduledTimerWithTimeInterval(1/2, target: self.revealedCard!, selector: Selector("flipDown"), userInfo: nil, repeats: false)
                    
                    var timer2 = NSTimer.scheduledTimerWithTimeInterval(1/2, target: cardThatWasTapped, selector: Selector("flipDown"), userInfo: nil, repeats: false)

            
                    // reset the revealed card
                    self.revealedCard = nil
                    
                }
            }
        }

        
    } // end func CardTapped
    
    func flipDownAllCards() {
        
        for card in self.cards {
            
            if (card.isDone == false){
                card.flipDown()
            }
            
           
            
        }
    }

}

