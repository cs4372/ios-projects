//
//  Extensions.swift
//  ChatApp
//
//  Created by Catherine Shing on 5/20/23.
//

import UIKit

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
