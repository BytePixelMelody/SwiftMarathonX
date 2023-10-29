//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // MARK: Constants
    
    private enum Constants {
        static let timers: [String: Float] = ["softButton": 300.0, "mediumButton": 420.0, "hardButton": 700.0]
        
        static let fullProgress: Float = 1.0
        static let timerInterval: Float = 1.0
        static let timerTolerance = 0.1
        
        static let questionText = "How do you like your eggs?"
        static let readyText = "Ready!"
        
        static let soundName = "alarm_sound"
        static let soundType = "mp3"
        static let playerVolume: Float = 0.3
    }
    
    // MARK: IBOutlet
    
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var progressView: UIProgressView!

    // MARK: Private Properties
    
    private var timerTask: Task<Void, Error>?
    private lazy var timer = Timer()
    private lazy var dateComponentsFormatter = {
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.allowedUnits = [.hour, .minute, .second]
        dateComponentsFormatter.unitsStyle = .positional
        return dateComponentsFormatter
    }()
    
    var player: AVAudioPlayer?
    
    // MARK: UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: IBAction

    @IBAction func hardnessSelected(_ sender: UIButton) {
        guard let restorationIdentifier = sender.restorationIdentifier,
              let seconds = Constants.timers[restorationIdentifier]
        else {
            return
        }
        
        setTaskTimer(for: seconds)
    }
    
    // MARK: Private Methods
    
    private func setTaskTimer(for totalSeconds: Float) {
        timerTask?.cancel()
        
        timerTask = Task { [self] in
            var currentSeconds = totalSeconds
                        
            // without animation
            await setBarProgress(current: currentSeconds, total: totalSeconds, animated: false)

            while currentSeconds > .zero {
                guard let timerTask, !timerTask.isCancelled else { return }

                await setLabelProgress(seconds: currentSeconds)
                await setBarProgress(current: currentSeconds, total: totalSeconds, animated: true)

                currentSeconds -= Constants.timerInterval
                
                let sleepSeconds = Double(Constants.timerInterval)
                try await Task.sleep(for: .seconds(sleepSeconds))
            }
            await setLabelProgress(seconds: currentSeconds)
            await setBarProgress(current: currentSeconds, total: totalSeconds, animated: true)
            playSound()
        }
    }
    
    @MainActor
    private func setLabelProgress(seconds: Float) async {
        var text: String?
        let seconds = seconds.rounded(.up)
        
        if seconds == .zero {
            text = Constants.readyText
        } else {
            text = dateComponentsFormatter.string(from: TimeInterval(seconds))
        }
        
        if timerLabel.text != text {
            timerLabel.text = text
        }
    }
    
    @MainActor
    private func setBarProgress(current: Float, total: Float, animated: Bool) async {
        let progress = total == .zero ? Constants.fullProgress : current / total
        progressView.setProgress(progress, animated: animated)
    }
    
    private func playSound() {
        guard let url = Bundle.main.url(forResource: Constants.soundName, withExtension: Constants.soundType) else {
            print("Sound URL is invalid")
            return
        }
                
        do {
            // activate AVAudioSession before audio playback
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.volume = Constants.playerVolume
            player?.prepareToPlay()
            player?.play()
        } catch {
            print(error)
        }
    }
    
    // MARK: by Angela
    
    private func setStrictTimer(for seconds: Float) {
        timerLabel.text = Constants.questionText
        progressView.progress = Constants.fullProgress
        
        var currentSeconds = seconds
        
        // deactivate old Timer
        timer.invalidate()
        
        // replace old Timer by new one
        timer = Timer.scheduledTimer(withTimeInterval: Double(Constants.timerInterval), repeats: true, block: { [self] timer in
            if currentSeconds > .zero {
                let progress = currentSeconds / seconds
                progressView.setProgress(progress, animated: true)
                
                currentSeconds -= Constants.timerInterval
            } else {
                progressView.setProgress(.zero, animated: true)
                timerLabel.text = Constants.readyText
                timer.invalidate()
            }
        })
        
        timer.tolerance = Constants.timerTolerance
        timer.fire()
    }
    
}

extension ViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // clean text
        timerLabel.text = nil
        
        // deactivate AVAudioSession
        do {
            // deactivate AVAudioSession after audio playback
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print(error)
        }
    }
}
