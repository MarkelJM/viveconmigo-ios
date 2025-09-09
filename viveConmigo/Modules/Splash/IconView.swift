//
//  IconView.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 2/3/25.
//


import SwiftUI

struct IconView: View {
    @State private var showEsloganEUS = false
    @State private var showEsloganES = false
    @EnvironmentObject var appState: AppState
    let soundManager = SoundManager.shared
    @State private var progress: CGFloat = 0.0


    var body: some View {
        ZStack {
            Fondo()
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                VStack {
                    Text("Bienvenido a Madrid")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.mateGold)
                        .padding(.top, 20)
                    
                    Text("¡Logra todos tus retos!")
                        .font(.title2)
                        .foregroundColor(.mateGold)
                        .padding(.bottom, 20)
                }
                .padding(30)
                .background(Color.black.opacity(0.5))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.mateGold, lineWidth: 2)
                )
                .padding(.horizontal, 40)

                Image("personajeOso")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.7), radius: 10, x: 0, y: 10)
                    .padding()

                Spacer()

                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .mateGold))
                    .frame(width: 200)
                    .padding(.bottom, 40)
            }
        }
        .onAppear {
            startProgress()
            soundManager.playInitialSound()
        }
    }

    private func startProgress() {
        withAnimation(.easeInOut(duration: 2.0)) {
            progress = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let _ = KeychainManager.shared.read(key: "userUID") {
                appState.currentView = .challengeList
            } else {
                appState.currentView = .login
            }
        }
    }
    
    /*
    var body: some View {
        ZStack {
            Fondo()
                .edgesIgnoringSafeArea(.all)

            VStack {
                Image("iconoMadrid")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.7), radius: 10, x: 0, y: 10)
                    .padding(.top, 50)
                ZStack {
                    if showEsloganES {
                        Image("ESLOGAN1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 350, height: 120) // Ajustamos el tamaño
                            .offset(x: -UIScreen.main.bounds.width * 0.2, y: 30) // Posicionamos hacia la izquierda
                            .transition(.opacity)
                    }

                    if showEsloganEUS {
                        Image("ESLOGAN2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 350, height: 120) // Ajustamos el tamaño
                            .offset(x: UIScreen.main.bounds.width * 0.2, y: 200) // Posicionamos hacia la derecha
                            .transition(.opacity)
                    }
                }
                .padding(.top, 50)

                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            soundManager.playInitialSound()
        }
    }

    private func startAnimations() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeIn(duration: 1.0)) {
                showEsloganES = true
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeIn(duration: 1.0)) {
                showEsloganEUS = true
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            if let _ = KeychainManager.shared.read(key: "userUID") {
                appState.currentView = .challengeList
            } else {
                appState.currentView = .login
            }
        }
    }
    
    */
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconView()
            .environmentObject(AppState())
    }
}





/*
 
 
 
 
 
 
 import SwiftUI

 struct IconView: View {
     @State private var showEsloganEUS = false
     @State private var showEsloganES = false
     @EnvironmentObject var appState: AppState
     let soundManager = SoundManager.shared
     @State private var progress: CGFloat = 0.0


     var body: some View {
         ZStack {
             Fondo()
                 .edgesIgnoringSafeArea(.all)

             VStack {
                 Spacer()

                 VStack {
                     Text("Bienvenido a Tenerife Challenge")
                         .font(.largeTitle)
                         .fontWeight(.bold)
                         .foregroundColor(.mateGold)
                         .padding(.top, 20)
                     
                     Text("¡Logra todos tus retos!")
                         .font(.title2)
                         .foregroundColor(.mateGold)
                         .padding(.bottom, 20)
                 }
                 .padding(30)
                 .background(Color.black.opacity(0.5))
                 .cornerRadius(20)
                 .overlay(
                     RoundedRectangle(cornerRadius: 20)
                         .stroke(Color.mateGold, lineWidth: 2)
                 )
                 .padding(.horizontal, 40)

                 Image("iconLogo")
                     .resizable()
                     .scaledToFit()
                     .frame(width: 200, height: 200)
                     .clipShape(RoundedRectangle(cornerRadius: 20))
                     .shadow(color: .black.opacity(0.7), radius: 10, x: 0, y: 10)
                     .padding()

                 Spacer()

                 ProgressView(value: progress)
                     .progressViewStyle(LinearProgressViewStyle(tint: .mateGold))
                     .frame(width: 200)
                     .padding(.bottom, 40)
             }
         }
         .onAppear {
             startProgress()
             soundManager.playInitialSound()
         }
     }

     private func startProgress() {
         withAnimation(.easeInOut(duration: 2.0)) {
             progress = 1.0
         }
         
         DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
             if let _ = KeychainManager.shared.read(key: "userUID") {
                 appState.currentView = .challengeList
             } else {
                 appState.currentView = .login
             }
         }
     }
 }

 struct IconView_Previews: PreviewProvider {
     static var previews: some View {
         IconView()
             .environmentObject(AppState())
     }
 }
 */
