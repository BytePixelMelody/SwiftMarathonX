//
//  ViewController.swift
//  Magic 8 Ball
//
//  Created by Angela Yu on 14/06/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Constants
    
    private enum Constants {
        static let ballArray = [#imageLiteral(resourceName: "ball1"),#imageLiteral(resourceName: "ball2"),#imageLiteral(resourceName: "ball3"),#imageLiteral(resourceName: "ball4"),#imageLiteral(resourceName: "ball5.png")]
    }
    
    // MARK: IBOutlet
    
    @IBOutlet var ballImage: UIImageView!
        
    // MARK: UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        randomBall()
    }

    // MARK: IBAction
    
    @IBAction func askButtonPressed(_ sender: UIButton) {
        randomBall()
    }
    
    // MARK: Private Methods
    
    private func randomBall() {
        ballImage.image = Constants.ballArray.randomElement()
    }

}

