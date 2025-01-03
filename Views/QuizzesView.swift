//
//  QuizzesView.swift
//  Quiz
//
//  Created by d121 DIT UPM on 25/11/24.
//


import SwiftUI


struct QuizzesView: View{
    
    @Environment(ScoresModel.self) var scoresModel
    @Environment(QuizzesModel.self) var quizzesModel:QuizzesModel
    @State var showAll: Bool = true
    //@State var showErrorMsgAlert = false
    //@State var isFirstLoad = true

    var body: some View{
        NavigationStack{
            List {
                Toggle("Show All", isOn: $showAll)
                ForEach(quizzesModel.quizzes) {quizItem in
                    if showAll || !scoresModel.acertados.contains(quizItem.id) {
                        NavigationLink(destination: QuizPlayView(quizItem: quizItem))
                        {
                            QuizRowView(quizItem: quizItem)
                        }
                    }
                }
            }
            
            .listStyle(.plain)
            .navigationTitle("Quizzes")
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Image(systemName: "hand.thumbsup")
                    Text("Score: \(scoresModel.acertados.count)")
                        .font(.headline)
                    Image(systemName: "medal")
                    Text("Record: \(scoresModel.record.count)")
                        .font(.headline)
                    
                }
                ToolbarItemGroup(placement: .topBarTrailing){
                        Button("reload"){
                        
                            Task{
                                await quizzesModel.download()
                                scoresModel.limpiar()
                        }
                    }
                }
            }
        
        }
        
        .padding()
        .task {
            print("estoy cargando los datos")
            if quizzesModel.quizzes.count == 0{
                await quizzesModel.download()
            }
        }
        
        
    }
}

#Preview{
    @Previewable @State var model = QuizzesModel()
    @Previewable @State var scoresModel = ScoresModel()

    QuizzesView()
        .environment(model)
        .environment(scoresModel)
        
}
