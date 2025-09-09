//
//  DailyTaskView.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 11/6/25.
//

import SwiftUI

struct DailyTaskView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            Fondo()

            VStack(spacing: 30) {
                Text("Estas son las tareas diarias, hoy tocan las siguientes:")
                    .font(.title2)
                    .foregroundColor(.mateGold)
                    .padding()
                    .multilineTextAlignment(.center)

                // Botón 1 – Ir a una pregunta fija
                Button(action: {
                    appState.currentView = .questionAnswer(id: "daily_001")
                }) {
                    Text("Responder pregunta del día")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.mateBlueMedium)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                // Botón 2 y 3 (placeholders)
                Button(action: {
                    appState.currentView = .dailyWalking
                }) {
                    Text("Camina 500 metros")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.mateBlueMedium)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }


                Button(action: {
                    appState.currentView = .takePhoto(id: "daily_003")
                }) {
                    Text("Haz tu retrato y tómale una foto")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.mateBlueMedium)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

            }
            .padding()
            .background(Color.black.opacity(0.5))
            .cornerRadius(20)
            .padding()
        }
    }
}


#Preview {
    DailyTaskView()
        .environmentObject(AppState())
}
