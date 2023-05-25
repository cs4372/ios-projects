//
//  Extensions.swift
//  ChatApp
//
//  Created by Catherine Shing on 5/20/23.
//

import UIKit
import FirebaseAuth

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImageUsingCache(urlString: String) {
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print("Error downloading profile image: \(error)")
                return
            }
            
            if let data = data, let downloadedImage = UIImage(data: data) {
                imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                
                DispatchQueue.main.async {
                    self?.image = downloadedImage
                }
            }
        }.resume()
    }
}

extension AuthErrorCode.Code {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account. Pick another email!"
        case .userNotFound:
            return "Account not found for the specific user. Please check and try again."
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email."
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password is incorrect."
        default:
            return "Sorry, something went wrong."
        }
    }
}

extension UIViewController{
    func handleError(_ error: Error) {
        
        if let errorCode = AuthErrorCode.Code(rawValue: error._code) {
            print(errorCode.errorMessage)
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)

            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)

            alert.addAction(okAction)

            self.present(alert, animated: true, completion: nil)

        }
    }
}
