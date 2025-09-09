//
//  VerificationEmailView.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 28/5/25.
//


import SwiftUI

struct VerificationEmailView: View {
    @ObservedObject var viewModel: RegisterViewModel

    var body: some View {
        ZStack {
            // Fondo con imagen o gradiente
            Fondo()

            VStack(spacing: 20) {
                Text("¿Has verificado tu correo electrónico?")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.mateGold) // Usamos mateGold
                    .padding(.top, 50)

                // Botón para verificar correo
                Button(action: {
                    viewModel.checkEmailVerification()
                }) {
                    Text("OK")
                        .foregroundColor(.mateWhite) // Texto blanco
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.mateGold) // Fondo oro mate
                        .cornerRadius(10)
                }
                .padding(.bottom, 50)

                if viewModel.showError {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .background(Color.black.opacity(0.5))
            .cornerRadius(20)
            .padding()
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    VerificationEmailView(viewModel: RegisterViewModel())
}
