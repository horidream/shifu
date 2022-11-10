//
//  ImagePicker.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/11/9.
//

import SwiftUI
import UIKit

public struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage?
    public init(sourceType: UIImagePickerController.SourceType = .photoLibrary, selectedImage: Binding<UIImage?>) {
        self.sourceType = sourceType
        _selectedImage = selectedImage
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator

        return imagePicker
    }

    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final public class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }

            parent.dismiss()
        }
    }
}

