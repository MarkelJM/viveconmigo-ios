//
//  AvatarSelectionView.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 28/5/25.
//


import SwiftUI

struct AvatarSelectionView: View {
    @Binding var selectedAvatar: Avatar

    var body: some View {
        VStack {
            Text("Selecciona tu Avatar")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.mateGold) // Usamos mateGold
                .padding()

            HStack {
                Button(action: {
                    selectedAvatar = .boy
                }) {
                    Image("alien1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(selectedAvatar == .boy ? Color.mateGold : Color.clear, lineWidth: 4)
                        )
                        .shadow(radius: selectedAvatar == .boy ? 10 : 0)
                }

                Button(action: {
                    selectedAvatar = .girl
                }) {
                    Image("alien2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(selectedAvatar == .girl ? Color.mateGold : Color.clear, lineWidth: 4)
                        )
                        .shadow(radius: selectedAvatar == .girl ? 10 : 0)
                }
            }
            .padding()
        }
        .padding()
        .background(Color.black.opacity(0.5))
        .cornerRadius(20)
        .padding(.horizontal, 40)
    }
}

struct AvatarSelectionView_Previews: PreviewProvider {
    @State static var selectedAvatar: Avatar = .boy
    
    static var previews: some View {
        AvatarSelectionView(selectedAvatar: $selectedAvatar)
    }
}

