//
//  EditProfileView.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import SwiftUI

struct EditProfileView: View {
    @Binding var editedFirstName: String
    @Binding var editedLastName: String
    @Binding var editedPostalCode: String
    @Binding var editedCity: String
    @Binding var editedProvince: Province
    @Binding var editedAvatar: Avatar  // Binding para el avatar seleccionado
    var onSave: () -> Void
    var onCancel: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Información Personal")) {
                    TextField("Nombre", text: $editedFirstName)
                    TextField("Apellido", text: $editedLastName)
                    TextField("Código Postal", text: $editedPostalCode)
                        .keyboardType(.numberPad)
                    TextField("Ciudad", text: $editedCity)
                    
                    Picker("Provincia", selection: $editedProvince) {
                        ForEach(Province.allCases) { province in
                            Text(province.rawValue).tag(province)
                        }
                    }
                }
                
                Section(header: Text("Avatar")) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Selecciona tu Avatar")
                            .font(.headline)
                            .padding(.leading, 10) // Desplazamos el texto un poco hacia la izquierda

                        Picker(selection: $editedAvatar, label: Text("")) {
                            ForEach(Avatar.allCases) { avatar in
                                Text(avatar.rawValue.capitalized)
                                    .tag(avatar)
                            }
                        }
                        .pickerStyle(MenuPickerStyle()) // Estilo de selección como un menú desplegable
                        .padding(.leading, 80) // Desplazamos el picker un poco hacia la izquierda

                        Image(editedAvatar.rawValue)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80) // Ajuste del tamaño de la imagen del avatar
                            .padding(.top, 10)
                            .padding(.leading, 10)
                    }
                    .padding(.vertical)
                }
                
                Section {
                    Button(action: onSave) {
                        Text("Guardar")
                            .foregroundColor(.blue)
                    }
                    Button(action: onCancel) {
                        Text("Cancelar")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Editar Perfil")
        }
    }
}
