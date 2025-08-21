//
//  ProfileView.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 28/5/25.
//


import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            // Fondo con gradiente suave o imagen de fondo
            Fondo()

            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Button(action: {
                            appState.currentView = .onboardingTwo
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.headline)
                                .padding()
                                .background(Color.mateGold) // Usamos mateGold
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                        Spacer()
                    }

                    Text("Perfil")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.mateGold) // Usamos mateGold
                        .padding(.top, 50)

                    TextField("Nombre", text: $viewModel.firstName)
                        .padding()
                        .background(Color.mateWhite.opacity(0.8)) // Usamos mateWhite
                        .cornerRadius(10)
                        .padding(.horizontal, 40)

                    TextField("Apellido", text: $viewModel.lastName)
                        .padding()
                        .background(Color.mateWhite.opacity(0.8)) // Usamos mateWhite
                        .cornerRadius(10)
                        .padding(.horizontal, 40)

                    DatePicker("Fecha de Nacimiento", selection: $viewModel.birthDate, displayedComponents: .date)
                        .padding()
                        .background(Color.mateWhite.opacity(0.8)) // Usamos mateWhite
                        .cornerRadius(10)
                        .padding(.horizontal, 40)

                    TextField("Código Postal", text: $viewModel.postalCode)
                        .padding()
                        .background(Color.mateWhite.opacity(0.8)) // Usamos mateWhite
                        .cornerRadius(10)
                        .padding(.horizontal, 40)

                    TextField("Ciudad", text: $viewModel.city)
                        .padding()
                        .background(Color.mateWhite.opacity(0.8)) // Usamos mateWhite
                        .cornerRadius(10)
                        .padding(.horizontal, 40)

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Selecciona tu provincia")
                            .font(.headline)
                            .foregroundColor(.mateGold) // Usamos mateGold
                            .padding(.horizontal, 40)

                        Picker("Provincia", selection: $viewModel.province) {
                            ForEach(Province.allCases) { province in
                                Text(province.rawValue).tag(province)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .background(Color.mateWhite.opacity(0.8)) // Usamos mateWhite
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                    }

                    AvatarSelectionView(selectedAvatar: $viewModel.avatar)
                        .padding()

                    // Botón para guardar perfil
                    Button(action: {
                        viewModel.saveUserProfile {
                            self.appState.currentView = .challengeList
                        }
                    }) {
                        Text("Guardar Perfil")
                            .foregroundColor(.mateWhite) // Texto blanco
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.mateGold) // Fondo oro mate
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 50)
                    
                    Spacer()

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
            .onAppear {
                viewModel.fetchUserProfile()
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}



#Preview {
    ProfileView(viewModel: ProfileViewModel())
        .environmentObject(AppState())
}


