//
//  ContentView.swift
//  challenge4
//
//  Created by Aluno Mack on 28/04/25.
//
import Foundation
import SwiftUI
import PhotosUI
import CoreML

struct ContentView: View {
    var coreMLViewModel = CoreMLViewModel()
    @State var classificationLabel: String = ""
    @State var pickerImage: PhotosPickerItem?
    @State var selectedImage: UIImage?
    @State private var hasTimeElapsed = false
    @State var imagemSaida :String = "virgem"
    
    var body: some View {
        
        //            Color.purple.ignoresSafeArea()
        ZStack{
            // Background Color
            Circle()
                .fill(
                    RadialGradient(colors: [.roxo3, .roxo2, .roxo1], center: .center, startRadius: 380, endRadius: -200)
                )
                .frame(width: 3750, height: 3750)
            
            
            VStack{
                
                PhotosPicker( selection: $pickerImage, matching: .images,
                              photoLibrary: .shared()
                )
                {
                    VStack {
                        if selectedImage != nil {
                            if hasTimeElapsed {
                                Text("Parabéns !")
                                    .font(.title)
                                    .bold()
                                    .foregroundStyle(.white)
                                Text("Mais um \(classificationLabel)")
                                    .font(.title)
                                    .bold()
                                    .foregroundStyle(.white)
                                Image("estrela2")
                                    .resizable()
                                    .padding(.leading, -5.0)
                                    .frame(width:270, height: 270)
                                
                            } else {
                                Text("Calma, tô pensando...")
                                    .font(.title)
                                    .bold()
                                    .foregroundStyle(.white)
                                    .task(delay)
                                
                                // TODO: Here goes the gif
                                GifImage("star")
                                //                                        .resizable()
                                    .frame(width:366, height: 366)
                                    .padding(.leading, -5.0)
                                //                                        .opacity(0)
                                //                                        .padding(.leading)
                                //                                        .background(Color.white.opacity(0.001))
                            }
                        }
                        else {
                            Text("Qual é o seu signo ?")
                                .font(.title)
                                .bold()
                                .foregroundStyle(.white)
                            Image("estrela1")
                                .resizable()
                                .padding(.leading, -5.0)
                                .frame(width:366, height: 366)
                        }
                    }
                }
                if selectedImage != nil {
                    if hasTimeElapsed {
                        
                        Text("Conheço muitos do seu tipinho...")
                                .font(.title3)
                                .bold()
                                .foregroundStyle(.white)
                        
//                        Text("do seu tipinho...")
//                            .font(.title2)
//                            .bold()
//                            .foregroundStyle(.white)
                        
                        ScrollView{
                            Image(imagemSaida)
                                .cornerRadius(5)
                        }
                        .frame(height: 350)
                        
//                        HStack(content: {
//                            ScrollView(.horizontal){}
//                            Text("->")
//
//                        }
                        
                            
                            
                        
                        
                    }
                    else {
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 366, height: 366)
                    }
                }
            }
        }
        
        .padding()
        .onChange(of: pickerImage) {
            Task {
                guard let imageData = try await pickerImage?.loadTransferable(type: Data.self) else { return }
                guard let inputImage = UIImage(data: imageData) else { return }
                selectedImage = inputImage
                classificationLabel = coreMLViewModel.checkImage(selectedImage!)
                
                let dicionarioSignos: [String: [String]] = [
                    "Aries": ["Ariano", "aries"],
                    "Aquário": ["Aquariano", "aquario"],
                    "Câncer": ["Canceriano", "cancer"],
                    "Capricórnio": ["Capricorniano", "capricornio"],
                    "Escorpião": ["Escorpiano", "borboleta"],
                    "Gêmeo": ["Geminiano", "gemeo"],
                    "Leão": ["Leonino", "leao"],
                    "Libras": ["Libriano", "libra"],
                    "Peixes": ["Pisciano", "peixes"],
                    "Sagitário": ["Sagitariano", "sagitaro"],
                    "Touro": ["Taurino", "touro"],
                    "Virgem": ["Virginiano", "virgem"]]
                
                var significado :String = classificationLabel
                
                
                for (signo, saida) in dicionarioSignos {
                    if signo == significado{
                        significado = saida[0]
                        imagemSaida = saida[1]
                        break
                    }
                }
                classificationLabel = significado
                //
                //                Text("Parabéns, mais um \(significado)")
            }
        }
    }
    
    private func delay() async {
        // Delay of 7.5 seconds (1 second = 1_000_000_000 nanoseconds)
        try? await Task.sleep(nanoseconds: 12_010_000_000)
        hasTimeElapsed = true
    }
}

#Preview {
    ContentView()
}

