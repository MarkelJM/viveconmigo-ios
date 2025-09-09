//
//  ContactView.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import SwiftUI

struct ContactSheetView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Contacto")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("Si tienes alguna pregunta, inquietud o necesitas asistencia relacionada con nuestra aplicación, estamos aquí para ayudarte. Puedes ponerte en contacto con nuestro equipo de soporte a través de la siguiente información de contacto. Nos esforzamos por responder lo antes posible para ofrecerte la mejor experiencia posible.")
                .padding()

            Text("Email de contacto: conquistacyl@gmail.com")
                .font(.headline)
                .foregroundColor(.mateBlueMedium) // Usamos mateBlueMedium
                .padding()

            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContactSheetView()
}
