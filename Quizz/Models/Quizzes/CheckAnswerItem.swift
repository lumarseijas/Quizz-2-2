//
//  AnswerItem.swift
//  Quizz
//
//  Created by d121 DIT UPM on 16/12/24.
//

import Foundation

struct CheckAnswerItem: Codable{
    let quizId: Int
    let answer: String
    let result: Bool
}

