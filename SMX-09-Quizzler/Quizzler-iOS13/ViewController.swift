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
        static let questions: [Question] = [
            Question(q: "A slug's blood is green.", a: "True"),
            Question(q: "Approximately one quarter of human bones are in the feet.", a: "True"),
            Question(q: "The total surface area of two human lungs is approximately 70 square metres.", a: "True"),
            Question(q: "In West Virginia, USA, if you accidentally hit an animal with your car, you are free to take it home to eat.", a: "True"),
            Question(q: "In London, UK, if you happen to die in the House of Parliament, you are technically entitled to a state funeral, because the building is considered too sacred a place.", a: "False"),
            Question(q: "It is illegal to pee in the Ocean in Portugal.", a: "True"),
            Question(q: "You can lead a cow down stairs but not up stairs.", a: "False"),
            Question(q: "Google was originally called 'Backrub'.", a: "True"),
            Question(q: "Buzz Aldrin's mother's maiden name was 'Moon'.", a: "True"),
            Question(q: "The loudest sound produced by any animal is 188 decibels. That animal is the African Elephant.", a: "False"),
            Question(q: "No piece of square dry paper can be folded in half more than 7 times.", a: "False"),
            Question(q: "Chocolate affects a dog's heart and nervous system; a few ounces are enough to kill a small dog.", a: "True")
        ]
        static let resultText = "Your score is "
        static let buttonAnimationDuration = 0.3
        
        static let defaultColor = "buttonBackgroundColor"
        static let correctColor = "buttonCorrectColor"
        static let incorrectColor = "buttonIncorrectColor"
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
        
        configureButtons()
        setQuestion()
    }
    
    // MARK: IBAction

    @IBAction func answerButtonPressed(_ sender: UIButton) {
        let answerCorrectness = isAnswerCorrect(answer: sender.configuration?.title)
        
        increaseProgressBar()
        setButtonColor(button: sender)
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in
            blinkTap(button: sender, color: .red)
        })
        
        if questionNumber + 1 < Constants.questions.count {
            questionNumber += 1
            setQuestion()
        } else {
            showResult()
            restart()
        }
    }
    
    // MARK: Private Methods
    
    private func configureButtons() {
        let trueButtonBackgroundView = UIView(frame: .zero)
        trueButtonBackgroundView.backgroundColor = UIColor(named: Constants.defaultColor)
        trueButton.configuration?.background.customView = trueButtonBackgroundView
        
        let falseButtonBackgroundView = UIView(frame: .zero)
        falseButtonBackgroundView.backgroundColor = UIColor(named: Constants.defaultColor)
        falseButton.configuration?.background.customView = falseButtonBackgroundView
    }
    
    private func setQuestion() {
        questionLabel.text = Constants.questions[questionNumber].text
    }
    
    private func isAnswerCorrect(answer: String?) -> Bool {
        answer == Constants.questions[questionNumber].answer
    }
    
    private func changeScore(answerCorrectness: Bool) {
        if answerCorrectness {
            score += 1
        }
    }
    
    private func setButtonColor(button: UIButton, answerCorrectness: Bool) {
        let color: UIColor
        if answerCorrectness {
            color = UIColor(named: Constants.correctColor) ?? .green
        } else {
            color = UIColor(named: Constants.incorrectColor) ?? .red
        }
        button.configuration?.background.customView?.backgroundColor = color
    }
    
    @objc
    private func blinkTap(button: UIButton, color: UIColor) {
        button.configuration?.background.customView?.backgroundColor = color

        UIView.transition(
            with: button,
            duration: Constants.buttonAnimationDuration,
            options: [.allowUserInteraction, .curveEaseOut]
        ) {
            button.configuration?.background.customView?.backgroundColor = UIColor(named: Constants.defaultColor)
        }
    }

    private func increaseProgressBar() {
        progressBar.progress += 1.0 / Float(Constants.questions.count)
    }
    
    private func showResult() {
        questionLabel.text = "\(Constants.resultText)\(score)"
    }
    
    private func restart() {
        questionNumber = .zero
        score = .zero
        progressBar.progress = .zero
    }
        
}

