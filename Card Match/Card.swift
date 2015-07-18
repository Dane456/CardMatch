//
//  Card.swift
//  Card Match
//
//  Created by Dane Jordan on 1/18/15.
//  Copyright (c) 2015 Dane Jordan. All rights reserved.
//

import UIKit

class Card: UIView {
    
    var frontImageView:UIImageView = UIImageView()
    var backImageView:UIImageView = UIImageView()
    var cardValue:Int = 0
    var cardNames:[String] = ["ace", "card2", "card3", "card4", "card5", "card6", "card7", "card8", "card9", "card10", "jack", "queen", "king"]
    var isFlippled:Bool = false
    var isDone:Bool = false {
        
        didSet {
            //If the card is done, remove image
            if(isDone == true) {
                
                UIView.animateWithDuration(1, delay: 1, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    
                    self.frontImageView.alpha = 0
                    self.backImageView.alpha = 0
                    
                    }, completion: nil)
                
                
            }
        }
    }
    
    
    override init() {
        super.init()
        
        
        // set default image for the imageview
        backImageView.image = UIImage(named: "back")
        self.applySizeConstraintsToImage(self.backImageView)
        self.applyPositioningConstraintsToImage(self.backImageView)
        
        //Set autolayout constraints for the front
        self.applySizeConstraintsToImage(self.frontImageView)
        self.applyPositioningConstraintsToImage(self.frontImageView)
        
        
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        
        //Cal UIViews init with frame method and pass it the frame
        super.init(frame: frame)
    }

    func applySizeConstraintsToImage(imageView: UIImageView) {
        
        //add the imageview to the view
        self.addSubview(imageView)
        
        //Set translates autoresizing mask to false
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        
        //set the constraints for the imageview
        var heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 170)
        
        var widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 120)
        
        imageView.addConstraints([heightConstraint, widthConstraint])
        
        // Set the position of the image view

    }
    
    func applyPositioningConstraintsToImage(imageView:UIImageView) {
        
        var verticalConstraint:NSLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        
        var horizontalConstraint:NSLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        
        self.addConstraints([horizontalConstraint, verticalConstraint])
        
    }
    
    func flipUp() {
        //Set imageview to image that represents the card value
        self.frontImageView.image = UIImage(named: self.cardNames[self.cardValue])
        
        //Do animation
        UIView.transitionFromView(self.backImageView, toView: self.frontImageView, duration: 1/4, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
        
        //Add positioning constraints
        self.applyPositioningConstraintsToImage(self.frontImageView)
        
        
        self.isFlippled = true
    }
    
    func flipDown() {
        //Set the image view to the card back
        //Do animation
        UIView.transitionFromView(self.frontImageView, toView: self.backImageView, duration: 1/4, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
        
        //Add positioning constraints
        self.applyPositioningConstraintsToImage(self.backImageView)
        
        
        self.isFlippled = false
    }
}
