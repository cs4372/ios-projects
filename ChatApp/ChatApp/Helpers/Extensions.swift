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
           if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error downloading profile image: \(error)")
                    return
                }

                if let data = data {
                    DispatchQueue.main.async {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                            self.image = downloadedImage
                        }
                    }
                }
            }.resume()
        }
    }
}
