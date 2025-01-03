//
//  File.swift
//  Quiz
//
//  Created by d121 DIT UPM on 25/11/24.
//
//

import SwiftUI
import Foundation

struct QuizPlayView: View{
    @Environment(ScoresModel.self) var scoresModel
    //@Environment(\.horizontalSizeClass) var hsc
    @Environment(QuizzesModel.self) var quizzesModel : QuizzesModel// cambiado abajo
    @Environment(\.verticalSizeClass) var vsc
    @State var showAlert: Bool = false
    @State var showAlertResultRespuesta: Bool = false
    @State var resultCheckRespuesta: Bool = false
    @State var showAlertError: Bool = false
    @State var showSolution: Bool = false
    @State var msgError: String = ""{
        didSet{
            if !showSolution {
                showAlertError = true
            }
        }
    }
    
    var quizItem: QuizItem
    
    
    // creo que aqui va a poner algo
    
    @State var respuesta: String = ""
    
    
    
    var body : some View {
        
        if vsc != .compact{
            VStack(alignment: .center) {
                cabecera
                respuestaView
                attachment
                autor
            }
        }else{
            VStack{
                cabecera
                HStack(alignment: .center){
                    VStack{
                        respuestaView
                        autor
                    }
                    attachment
                    
                }
                
            }
        }
        
    }
    
    var respuestaView: some View{
        VStack{
            TextField("Respuesta",text: $respuesta)
                .onSubmit{ // clase 11 dic
                    checkAnswer()
                }
                .alert(resultCheckRespuesta ? "Correcto!" : "Mal", isPresented: $showAlertResultRespuesta){}
                .textFieldStyle(.roundedBorder)
            
            Button("Comprobar"){
                checkAnswer()
            }
            
        }
    }
    
    
    func checkAnswer(){
        // clase del 11 dic
        Task{
            do{
                if try await quizzesModel.checkAnswer(quizId: quizItem.id, answer: respuesta){
                    showAlertResultRespuesta = true
                    resultCheckRespuesta = true
                    scoresModel.meter(quizItem)
                    print("se tiene que hber metido el score")
                    
                }else{
                    showAlertResultRespuesta = true
                    resultCheckRespuesta = false
                }
            }catch{
                msgError = error.localizedDescription
                
            }
        }
    }
    
    
    
    var cabecera: some View{
        HStack{
            //pregunta
            Text(quizItem.question)
                .lineLimit(3)
                .font(.largeTitle)
                .bold()
                .font(.custom("Comic Sans MS", size: 24))
                .foregroundColor(.purple)
            //estrella
            Button{
                Task{
                    do{
                        try await quizzesModel.changeFavourites(quizItem: quizItem)
                    }catch {
                        throw QuizzesModelError.corruptedDataError
                    }
                }
            }label:{
                Image(systemName: quizItem.favourite ? "star.fill" : "star")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
        }
        
    }
    
    @State var rotacion: Double = 360
    @State var escala: Double = 1
    var attachment: some View{
        let attachmentUrl = self.quizItem.attachment?.url
        
        return GeometryReader{ geometry in
            EasyAsyncImage(url: attachmentUrl)
                .frame(width: geometry.size.width, height:geometry.size.height)
                .clipShape(RoundedRectangle(cornerRadius: 19))
                .overlay {
                    RoundedRectangle(cornerRadius: 19)
                        .stroke(Color.black, lineWidth: 4)
                }
                .saturation(self.showAlert ? 0 : 1)
                .animation(.easeInOut, value: self.showAlert)
                .shadow(radius: 10)
                .rotationEffect(Angle(degrees: rotacion))
                .scaleEffect(escala)
            //Mejora girafoto, sale respuesta
                .onTapGesture(count: 2){
                    Task{
                        do{
                            
                            rotacion = 180 - rotacion
                            //escala = 3 - escala
                            
                            respuesta = try await quizzesModel.answer(quizId: quizItem.id)
                        }catch {
                            msgError = "Error"
                        }
                        
                    }
                }
        }
        
        .animation(.easeInOut, value: rotacion)
        .padding()
    }
    
    
    
    var autor: some View {
        VStack(alignment: .trailing) {
            HStack{
                Spacer()
                Text(quizItem.author?.username ?? quizItem.author?
                    .profileName ?? "Anónimo")
                EasyAsyncImage(url: quizItem.author?.photo?.url)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(Color.brown, lineWidth: 1)
                    }
                    .contextMenu{
                        Button("Limpiar"){
                            respuesta = " "
                        }
                        Button("Solución"){
                            Task {
                                do {
                                    showSolution = true
                                    let respuestacorrecta = try await quizzesModel.answer(quizId: quizItem.id)
                                    respuesta = respuestacorrecta
                                }catch {
                                    msgError = "Error"
                                }
                            }
                        }
                        
                    }
            }
        }
    }
}


/*
 #Preview {
 @Previewable @State var quizzesModel = QuizzesModel()
 @Previewable @State var scoresModel = ScoresModel()
 
 let _ = quizzesModel.load()
 
 QuizPlayView(quizItem: quizzesModel.quizzes[14])
 .environment(scoresModel)
 }
 */
