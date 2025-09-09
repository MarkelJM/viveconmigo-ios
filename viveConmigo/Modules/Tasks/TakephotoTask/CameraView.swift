//
//  CameraView.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 28/5/25.
//


import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {
    var viewModel: TakePhotoViewModel

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.viewModel.capturedImage = image
                parent.viewModel.checkTakePhoto(isCorrect: true) // Verificamos la foto inmediatamente
            }
            picker.dismiss(animated: true)
        }
    }
}
