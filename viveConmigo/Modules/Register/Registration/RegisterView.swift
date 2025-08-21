//
//  RegisterView.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 28/5/25.
//



import SwiftUI

struct RegisterView: View {
   @EnvironmentObject var appState: AppState
   @ObservedObject var viewModel: RegisterViewModel
   @StateObject private var keyboardObserver = KeyboardObserver()

   var body: some View {
       ZStack {
           Fondo()
               .edgesIgnoringSafeArea(.all)
           
           ScrollView {
               VStack(spacing: 20) {
                   Text("Registra email")
                       .font(.largeTitle)
                       .fontWeight(.bold)
                       .foregroundColor(.mateGold)
                       .padding(.top, 50)
                   
                   TextField("Email", text: $viewModel.email)
                       .padding()
                       .background(Color.mateWhite.opacity(0.8))
                       .cornerRadius(10)
                       .padding(.horizontal, 40)
                   
                   SecureField("Contraseña", text: $viewModel.password)
                       .padding()
                       .background(Color.mateWhite.opacity(0.8))
                       .cornerRadius(10)
                       .padding(.horizontal, 40)
                   
                   SecureField("Repetir Contraseña", text: $viewModel.repeatPassword)
                       .padding()
                       .background(Color.mateWhite.opacity(0.8))
                       .cornerRadius(10)
                       .padding(.horizontal, 40)
                   
                   HStack {
                       Toggle(isOn: $viewModel.agreeToTerms) {
                           Text("He leído y acepto los")
                               .foregroundColor(.mateWhite)
                       }
                       .toggleStyle(CheckboxToggleStyle())
                       .padding(.horizontal, 10)
                       
                       Button(action: {
                           appState.currentView = .termsAndConditions
                       }) {
                           Text("Términos y Condiciones")
                               .foregroundColor(.blue)
                       }
                   }
                   .padding(.horizontal, 40)
                   
                   Button(action: {
                       viewModel.register()
                   }) {
                       Text("Registrarse")
                           .foregroundColor(.mateWhite)
                           .padding()
                           .frame(maxWidth: .infinity)
                           .background(Color.mateGold)
                           .cornerRadius(10)
                   }
                   .padding(.top, 20)
                   .padding(.bottom, 50)
                   .disabled(!viewModel.agreeToTerms)
                   
                   if viewModel.showError {
                       Text(viewModel.errorMessage)
                           .foregroundColor(.red)
                           .padding()
                   }
               }
               .background(Color.black.opacity(0.7))
               .cornerRadius(20)
               .padding()
               .padding(.bottom, keyboardObserver.keyboardHeight)
               .padding(.top, 100)
           }
       }
       .sheet(isPresented: $viewModel.showVerificationModal) {
           VerificationEmailView(viewModel: viewModel)
       }
       .onChange(of: viewModel.isVerified) { isVerified in
           if isVerified {
               appState.currentView = .profile
           }
       }
   }
}


struct CheckboxToggleStyle: ToggleStyle {
   func makeBody(configuration: Configuration) -> some View {
       Button(action: {
           configuration.isOn.toggle()
       }) {
           HStack {
               Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                   .foregroundColor(configuration.isOn ? .blue : .secondary)
               configuration.label
           }
       }
   }
}

#Preview {
   RegisterView(viewModel: RegisterViewModel())
       .environmentObject(AppState())
}



