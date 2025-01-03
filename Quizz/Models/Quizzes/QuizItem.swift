//
//  QuizItem.swift
//  Quiz
//
//  Created by Santiago Pavón Gómez on 18/10/24.
//

import Foundation

struct QuizItem: Codable, Identifiable {
    let id: Int
    let question: String
    //let answer: String
    let author: Author?
    let attachment: Attachment?
    var favourite: Bool //si es false la estrella es gris y si es true es amarilla
    
    struct Author: Codable {
        let isAdmin: Bool?
        let username: String?
        let profileName: String?
        let photo: Attachment?
    }
    
    struct Attachment: Codable {
        let filename: String?
        let mime: String?
        let url: URL?
    }
}
