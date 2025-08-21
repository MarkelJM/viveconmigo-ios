//
//  Fondo.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 2/3/25.
//



import SwiftUI

struct Fondo: View {
    var body: some View {
        ZStack {
            // Fondo con gradiente suave (Pantone 279 C a Pantone 288 C)
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 83/255, green: 143/255, blue: 213/255), // Pantone 279 C (Azul claro)
                Color(red: 0/255, green: 91/255, blue: 171/255),  // Pantone 7687 C (Azul medio)
                Color(red: 0/255, green: 46/255, blue: 93/255)   // Pantone 288 C (Azul oscuro)
            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea(edges: .all)
        }
    }
}

//  previa
#Preview {
    Fondo()
}
