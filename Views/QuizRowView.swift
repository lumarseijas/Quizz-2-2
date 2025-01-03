//
//  QuizRowView.swift
//  Quiz
//  Created by d121 DIT UPM on 25/11/24.
//

import SwiftUI

struct QuizRowView: View {
    var quizItem: QuizItem
    
    
    var body: some View {
        HStack {
            EasyAsyncImage(url: quizItem.attachment?.url)
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 19))
                .overlay {
                    RoundedRectangle(cornerRadius: 19)
                        .stroke(Color.black, lineWidth: 4)
                }
                .shadow(radius: 10)

            VStack(alignment: .trailing) {
                Image(quizItem.favourite ? "syellow" : "sgrey") // lo coje de quizid
                    .resizable()
                    .frame(width: 15, height: 15)
               
                
                Text(quizItem.question)
                    .lineLimit(3)
                    .font(.headline)

                HStack {
                    Spacer()
                    Text(quizItem.author?.username ?? quizItem.author?
                        .profileName ?? "Anónimo")

                    EasyAsyncImage(url: quizItem.author?.photo?.url)
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .overlay {
                            Circle().stroke(Color.brown, lineWidth: 1)
                        }
                }
            }
            .padding()
        }
    }
}
 
/*
#Preview {
    @Previewable @State var quizzesModel = QuizzesModel()
    //@Previewable @EnvironmentObject var favoritos: Favoritos
    @Previewable @EnvironmentObject var favoritos = Favourites()

    //@State var quizzesModel = QuizzesModel()
    let _ = quizzesModel.load()
                    QuizRowView(quizItem: quizzesModel.quizzes[4],isFavourite: true)
        .environmentObject(favoritos)
}
*/

