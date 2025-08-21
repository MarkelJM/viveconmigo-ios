//
//  CustomTabBar.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: AppState.AppView

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    selectedTab = .challengeList
                }) {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("Desafíos")
                    }
                }
                .frame(maxWidth: .infinity)

                Button(action: {
                    selectedTab = .mapContainer
                }) {
                    VStack {
                        Image(systemName: "map")
                        Text("Mapa")
                    }
                }
                .frame(maxWidth: .infinity)

                Button(action: {
                    selectedTab = .settings
                }) {
                    VStack {
                        Image(systemName: "gearshape")
                        Text("Ajustes")
                    }
                }
                .frame(maxWidth: .infinity)
                
                Button(action: {
                    selectedTab = .dailyTask
                }) {
                    VStack {
                        Image(systemName: "sun.max.fill")
                        Text("Tarea diaria")
                    }
                }
                .frame(maxWidth: .infinity)

                /*
                Button(action: {
                    selectedTab = .eventView
                }) {
                    VStack {
                        Image(systemName: "calendar")
                        Text("Eventos")
                    }
                }
                .frame(maxWidth: .infinity)
                 */
            }
            .frame(height: 80)
            .padding(.horizontal, 16)
            .background(Color.mateGold.opacity(0.8))
            
            .shadow(radius: 5)
            .edgesIgnoringSafeArea(.bottom)

        }
        
    }
}
