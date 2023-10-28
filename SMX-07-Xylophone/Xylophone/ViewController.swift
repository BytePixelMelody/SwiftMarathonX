//
//  ViewController.swift
//  Xylophone
//
//  Created by Angela Yu on 28/06/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

/// Xylophone screen
class ViewController: UIViewController {
    
    // MARK: Constants
    
    private enum Constants {
        static let soundDirectory = "Sounds"
        static let sounds = ["1": "C", "2": "D", "3": "E", "4": "F", "5": "G", "6": "A", "7": "B"]
        static let soundType = "wav"
    }
    
    // MARK: Private Properties
    
    var player: AVAudioPlayer?
    
    // MARK: UIViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAudioSession()
    }
    
    // MARK: IBAction

    @IBAction func keyPressed(_ sender: UIButton) {
        blinkTap(on: sender)
        
        guard let buttonID = sender.accessibilityIdentifier else {
            print("Button id not found")
            return
        }
        playSound(id: buttonID)
    }
    
    // MARK: Private Methods
    /// Set this code in SceneDelegate
    private func setAudioSession() {
        do {
            // duck others apps
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .duckOthers)
            // then use by AVAudioSession.sharedInstance().setActive(true) in starting playing sound
            // and AVAudioSession.sharedInstance().setActive(false) in AVAudioPlayerDelegate
        } catch {
            print(error)
        }
    }
    
    /// Plays sound by id
    /// - Parameter id: key for Constants.sounds dictionary
    private func playSound(id: String) {
        guard let url = Bundle.main.url(
            forResource: Constants.sounds[id],
            withExtension: Constants.soundType,
            subdirectory: Constants.soundDirectory
        ) else {
            print("Sound URL is invalid")
            return
        }
                
        do {
            // activate AVAudioSession before audio playback
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
    
    private func blinkTap(on button: UIButton) {
        button.alpha = 0.5
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .allowUserInteraction) {
            button.alpha = 1
        }
    }
    
}

// MARK: - AVAudioPlayerDelegate

extension ViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        do {
            // deactivate AVAudioSession after audio playback
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print(error)
        }
    }
}
