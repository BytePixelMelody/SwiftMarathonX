//
//  ViewController.swift
//  Quizzler-iOS13
//
//  Created by Vyacheslav on 06.11.2023.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Constants
    
    private enum Constants {
        static let questions = [
            ["Four + Two is equal to Six", "True"],
            ["Five - Three is greater than One", "True"],
            ["Three + Eight is less than Ten", "False"],
        ]
        static let resultText = "Your score is "
    }
    
    // MARK: IBOutlet
    
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var trueButton: UIButton!
    @IBOutlet var falseButton: UIButton!
    
    // MARK: Private Properties
    
    private var questionNumber = 0
    private var score = 0
    
    // MARK: UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setQuestion()
    }
    
    // MARK: IBAction

    @IBAction func answerButtonPressed(_ sender: UIButton) {
        checkAnswer(answer: sender.currentTitle)
        increaseProgressBar()
        
        if questionNumber + 1 < Constants.questions.count {
            questionNumber += 1
            setQuestion()
        } else {
            showResult()
            restart()
        }
    }
    
    // MARK: Private Methods
    
    private func setQuestion() {
        questionLabel.text = Constants.questions[questionNumber][0]
    }
    
    private func checkAnswer(answer: String?) {
        if answer == Constants.questions[questionNumber][1] {
            score += 1
        }
    }
    
    private func increaseProgressBar() {
        progressBar.progress += 1.0 / Float(Constants.questions.count)
    }
    
    private func showResult() {
        questionLabel.text = "\(Constants.resultText)\(score)"
    }
    
    private func restart() {
        questionNumber = 0
        score = 0
        progressBar.progress = 0
        setQuestion()
    }
        
}

