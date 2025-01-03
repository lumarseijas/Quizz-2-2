//
//  Endpoints.swift
//  Quizz
//
//  Created by d121 DIT UPM on 10/12/24.
//

import Foundation
import SwiftUI

struct Endpoints {
    private static let urlBase = "https://quiz.dit.upm.es/api"
    private static let token = "15c2a4fa6ed5a71fdce1"
    
    static func r10() throws -> URL {
        let surl = "\(urlBase)/quizzes/random10?token=\(token)"
        
        guard let url = URL(string: surl) else {
            throw QuizzesModelError.internalError(msg: "La URL \(surl) no es válida")
        }
        return url
    }
    
    static func checkAnswer (quizId: Int, answer: String) throws -> URL{
        guard let answerEscaped = answer.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else{
            throw QuizzesModelError.internalError(msg: "el parametro answer no es válido")
        }
        
        let surl = "\(urlBase)/quizzes/\(quizId)/check?answer=\(answerEscaped)&token=\(token)"//mal puesto
        
        guard let url = URL(string: surl) else {
            throw QuizzesModelError.internalError(msg: "la URL\(surl) no es valida")
        }
        return url
    }
    
    static func changeFav(quizId: Int) throws -> URL{
        let surl = "\(urlBase)/users/tokenOwner/favourites/\(quizId)?token=\(token)"
        guard let url = URL(string: surl) else {
            throw QuizzesModelError.internalError(msg: "la URL\(surl) no es valida")
        }
        return url
        
    }
    
    static func answer (quizId: Int) throws -> URL {
            
            let str = "\(urlBase)/quizzes/\(quizId)/answer?token=\(token)"
            
            guard let url = URL(string : str) else {
                throw QuizzesModelError.internalError(msg: "La URL \(str) no es valida")
            }
            
            return url
            
        }
    
}
