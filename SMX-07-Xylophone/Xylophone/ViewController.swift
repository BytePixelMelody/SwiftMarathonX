//
//  ViewController.swift
//  Xylophone
//
//  Created by Angela Yu on 28/06/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // MARK: Constants
    
    private enum Constants {
        static let soundDirectory = "Sounds"
        static let sounds = ["1": "C", "2": "D", "3": "E", "4": "F", "5": "G", "6": "A", "7": "B"]
        static let soundExtension = "wav"
    }
    
    // MARK: Private Properties
    
    var player: AVAudioPlayer?
    
    // MARK: UIViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: IBAction

    @IBAction func keyPressed(_ sender: UIButton) {
        guard let buttonID = sender.accessibilityIdentifier,
              let url = Bundle.main.url(
                forResource: Constants.sounds[buttonID],
                withExtension: Constants.soundExtension,
                subdirectory: Constants.soundDirectory
              )
        else {
            print("Button id not found or sound URL is invalid")
            return
        }
                
        do {
            // duck others apps
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.volume = 0.9
            player?.prepareToPlay()
            player?.play()
        } catch {
            print(error)
        }
        
    }
    
}

// MARK: - AVAudioPlayerDelegate

extension ViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print(error)
        }
    }
}
