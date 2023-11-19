//
//  Question.swift
//  Quizzler-iOS13
//
//  Created by Vyacheslav on 07.11.2023.
//

import Foundation

struct Question {
    var text: String
    var answer: String
    
    init(q text: String, a answer: String) {
        self.text = text
        self.answer = answer
    }
}
