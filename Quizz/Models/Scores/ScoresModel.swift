//
//  ScoresModel.swift
//  Quizz
//
//  Created by d121 DIT UPM on 25/11/24.
//

import Foundation
@Observable class ScoresModel {
    private(set) var acertados: Set<Int> = []
    private(set) var record: Set<Int> = []
    
    init() {
        record = Set(UserDefaults.standard.array(forKey: "record") as? [Int] ?? [])
    }
    
    func meter(_ quizItem: QuizItem) {
        acertados.insert(quizItem.id)
        print("número en acertados: \(acertados.count)")
        record.insert(quizItem.id)
        
        print("número en record:\(record.count)")
        UserDefaults.standard.set(Array(record), forKey: "record")
        
    }
    func limpiar(){
        acertados.removeAll()
    }
}
