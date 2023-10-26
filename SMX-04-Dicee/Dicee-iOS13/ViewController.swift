//
//  ViewController.swift
//  Dicee-iOS13
//
//  Created by Angela Yu on 11/06/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Constants
    
    private enum Constants {
        static let images = [#imageLiteral(resourceName: "DiceOne"), #imageLiteral(resourceName: "DiceTwo"), #imageLiteral(resourceName: "DiceThree"), #imageLiteral(resourceName: "DiceFour"), #imageLiteral(resourceName: "DiceFive"), #imageLiteral(resourceName: "DiceSix")] // #imageLiteral(), #colorLiteral()
    }
    
    // MARK: IBOutlet
    
    @IBOutlet var diceImageViewLeft: UIImageView!
    @IBOutlet var diceImageViewRight: UIImageView!
    
    // MARK: UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rollDices()
    }
    
    // MARK: IBAction

    @IBAction func rollButtonPressed(_ sender: UIButton) {
        rollDices()
    }
    
    // MARK: Private Methods
    
    private func rollDices() {
        diceImageViewLeft.image = Constants.images.randomElement()
        diceImageViewRight.image = Constants.images.randomElement()
    }
    
}

