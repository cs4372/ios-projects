//
//  PostViewController.swift
//  Instagram-Clone
//
//  Created by Catherine Shing on 3/3/23.
//

import UIKit
import Parse

class PostViewController:
    UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func displayAlert(title: String, message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
              imageView.image = image
          } else {
              print("Error getting image")
          }
          self.dismiss(animated: true, completion: nil)
      }
    
    
    @IBAction func selectImage(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
       imagePickerController.allowsEditing = false
       self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func postImage(_ sender: UIButton) {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
        if let image = imageView.image {
            var userPost = PFObject(className: "Post")
            userPost["imageName"] = commentTextField.text
            userPost["userId"] = PFUser.current()?.objectId
            if let imageData = image.pngData() {
                let imageFile = PFFileObject(name:"image.png", data:imageData)
                    userPost["imageFile"] = imageFile
                    userPost.saveInBackground { (succeeded, error) in
                        self.view.isUserInteractionEnabled = true
                        activityIndicator.stopAnimating()
                         if (succeeded) {
                             self.displayAlert(title: "Post created", message: "Your post has successfully posted")
                         } else {
                             print("error", error)
                             self.displayAlert(title: "Error posting image", message: "Please try again")
                         }
                        self.commentTextField.text = ""
                        self.imageView.image = nil
                    }
            }
        }
    }
}
