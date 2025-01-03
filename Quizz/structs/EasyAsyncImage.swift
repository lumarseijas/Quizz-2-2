//
//  File.swift
//  Quiz
//
//  Created by d121 DIT UPM on 25/11/24.
//


import SwiftUI
struct EasyAsyncImage: View{
   var url:URL?
   var body : some View{
       AsyncImage(url:url) { phase in
           if url == nil {
               Color.white
           } else if let Image = phase.image {
               Image.resizable()
           } else if phase.error != nil {
               Color.red
           } else{
               ProgressView()
           }
       }
   }
   
  
}
#Preview {
   // Proporcionar un URL válido para la previsualización
   //EasyAsyncImage(url: URL(string: "https://www.example.com/image.jpg"))
}



