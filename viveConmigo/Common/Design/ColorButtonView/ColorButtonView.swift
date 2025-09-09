//
//  ColorButtonView.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 2/3/25.
//


import SwiftUI

// Botón con color sólido personalizado (oro mate)
func goldButton(title: String, action: @escaping () -> Void) -> some View {
    Button(action: action) {
        Text(title)
            .foregroundColor(.mateWhite)
            .padding()
            .background(
                Capsule()
                    .fill(Color.mateGold) // Oro mate
            )
            .overlay(
                Capsule()
                    .stroke(Color.mateWhite, lineWidth: 2) // Borde blanco
            )
    }
}

// Botón con color sólido (Pantone 279 C - Azul Claro)
func blueButton(title: String, action: @escaping () -> Void) -> some View {
    Button(action: action) {
        Text(title)
            .foregroundColor(.mateWhite)
            .padding()
            .background(
                Capsule()
                    .fill(Color.mateBlueLight) // Azul claro (Pantone 279 C)
            )
    }
}

// Botón con gradiente lineal (Pantone 279 C y 7687 C)
func gradientButton(title: String, action: @escaping () -> Void) -> some View {
    Button(action: action) {
        Text(title)
            .foregroundColor(.mateWhite)
            .padding()
            .background(
                LinearGradient(gradient: Gradient(colors: [
                    Color.mateBlueLight, // Azul claro (Pantone 279 C)
                    Color.mateBlueMedium   // Azul medio (Pantone 7687 C)
                ]), startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .cornerRadius(10)
    }
}

// Botón con borde y fondo blanco personalizado (Pantone 288 C)
func borderedButton(title: String, action: @escaping () -> Void) -> some View {
    Button(action: action) {
        Text(title)
            .foregroundColor(Color.mateBlueDark) // Azul oscuro (Pantone 288 C)
            .padding()
            .background(Color.mateWhite)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.mateBlueDark, lineWidth: 2) // Borde azul oscuro
            )
    }
}

// Botón con fondo azul medio (Pantone 7687 C) y borde azul oscuro
func borderedBlueButton(title: String, action: @escaping () -> Void) -> some View {
    Button(action: action) {
        Text(title)
            .foregroundColor(.mateWhite)
            .padding()
            .background(Color.mateBlueMedium) // Azul medio (Pantone 7687 C)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.mateBlueDark, lineWidth: 2) // Borde azul oscuro (Pantone 288 C)
            )
    }
}
