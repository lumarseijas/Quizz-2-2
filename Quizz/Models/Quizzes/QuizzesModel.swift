//
//  QuizzesModel.swift
//  Quiz
//
//  Created by Santiago Pavón Gómez on 18/10/24.
//

import Foundation
import SwiftUI

/// Errores producidos en el modelo de los Quizzes
enum QuizzesModelError: LocalizedError {
    case internalError(msg: String)
    case corruptedDataError
    case unknownError
    case httpError(msg: String)

    var errorDescription: String? {
        switch self {
        case .internalError(let msg):
            return "Error interno: \(msg)"
        case .httpError(let msg):
            return "HTTP me ha sorprendido: \(msg)"
        case .corruptedDataError:
            return "Recibidos datos corruptos"
        case .unknownError:
            return "No chungo ha pasado"
       }
    }
}

@Observable class QuizzesModel { //modelo donde guardo mis quizzes
    
    // Los datos
    private(set) var quizzes = [QuizItem]() //array de quizzes vacío
    init() {
        print("Cache 0:",  URLCache.shared.memoryCapacity / 1024, "KB")
        //para tener mas capacidad:
        URLCache.shared.memoryCapacity = 244140 * 1024
        print("Cache 1:",  URLCache.shared.memoryCapacity / 1024, "KB")
    }
    func download()  async{
            do {
                let r10URL = try Endpoints.r10()
                
                
                let (data, response) = try await URLSession.shared.data(from: r10URL)
                
                if let httpResponse = response as? HTTPURLResponse {
                            print("Código HTTP recibido:", httpResponse.statusCode) // Imprime el status code
                        }
                guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                    throw QuizzesModelError.httpError(msg: "r10 prot http esta tonto")
                    
                }
                
                //print("Quizzes ==>", String(data: data, encoding: .utf8) ?? "JSON incorrecto") //si no lo consigue hacer escribe: JSON incorrecto
                
                guard let quizzes = try? JSONDecoder().decode([QuizItem].self, from: data)  else { /// aqui
                    throw QuizzesModelError.corruptedDataError
                }
                
                self.quizzes = quizzes
                
                print("Quizzes cargados")
            } catch {
                print(error.localizedDescription)
            }
        }
    func load() {
        do {
            guard let jsonURL = Bundle.main.url(forResource: "quizzes", withExtension: "json") else {
                throw QuizzesModelError.internalError(msg: "No encuentro quizzes.json")
            }
            
            let data = try Data(contentsOf: jsonURL)
            
            // print("Quizzes ==>", String(data: data, encoding: String.Encoding.utf8) ?? "JSON incorrecto")
            
            guard let quizzes = try? JSONDecoder().decode([QuizItem].self, from: data)  else {
                throw QuizzesModelError.corruptedDataError
            }
            
            self.quizzes = quizzes
            
            print("Quizzes cargados")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func checkAnswer(quizId: Int, answer: String) async throws -> Bool{ 
        let caURL = try Endpoints.checkAnswer(quizId: quizId, answer: answer )// answer: answer
        let (data, response) = try await URLSession.shared.data(from: caURL)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw QuizzesModelError.httpError(msg: "check Answer prot http esta fallando")
        }
        //print ("Quizzes ==>", String(data: data, encoding: .utf8) ?? "JSON incorrecto")
        guard let checkAnswerItem = try? JSONDecoder().decode(CheckAnswerItem.self, from: data) else {
            throw QuizzesModelError.corruptedDataError
        }
        //self.quizzes = quizzes
        print("tu respuesta es: ", answer)
        print("answer comprobada", checkAnswerItem.result, checkAnswerItem.answer)
        return checkAnswerItem.result
    }
    
    
    func answer (quizId: Int) async throws -> String {
            let aUrl = try Endpoints.answer(quizId: quizId)
            let (data, response) = try await URLSession.shared.data(from: aUrl)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200  else {
                throw QuizzesModelError.internalError(msg: "Valid answer prot http esta fallando" )
            }
            guard let answerItem = try? JSONDecoder().decode(AnswerItem.self, from: data)  else {
                throw QuizzesModelError.corruptedDataError
            }

            return answerItem.answer
                
            }
    
    
    func changeFavourites (quizItem :QuizItem) async throws{
        let url = try Endpoints.changeFav(quizId: quizItem.id)
        
        
        var request = URLRequest(url: url)
        request.httpMethod = quizItem.favourite ? "DELETE" : "PUT"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Imprime el status code
        if let httpResponse = response as? HTTPURLResponse {
                    print("Código HTTP recibido:", httpResponse.statusCode)
                }
        
        guard (response as? HTTPURLResponse)?.statusCode == 200  else {
            throw QuizzesModelError.internalError(msg: "Valid answer prot http esta fallando")
        }
                
                
                //quizItem.favourite
        guard let res = try? JSONDecoder().decode(FavouriteItem.self, from: data)  else {
            throw QuizzesModelError.unknownError
                    
                    //throw CustomError(message:"Datos recibidos corruptos.")
        }
        
        guard let index = quizzes.firstIndex(where:{qi in
            qi.id == quizItem.id
        })  else {
        throw QuizzesModelError.unknownError
        }
                
        quizzes[index].favourite = res.favourite
        
        
    }
    

    
} 
