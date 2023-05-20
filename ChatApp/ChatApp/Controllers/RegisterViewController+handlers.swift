//
//  RegisterViewController+handlers.swift
//  ChatApp
//
//  Created by Catherine Shing on 5/19/23.
//

import UIKit

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handleSelectImage() {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        
        if let selectedImage = selectedImage {
            profileImageView.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
