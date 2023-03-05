//
//  SignUpViewController.swift
//  Instagram-Clone
//
//  Created by Catherine Shing on 3/4/23.
//

import UIKit
import Parse

class SignupViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    func displayAlert(title: String, message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    @IBAction func userSignup(_ sender: UIButton) {
        let user = PFUser()
        user.username = usernameTextField.text
        user.email = emailTextField.text
        user.password = passwordTextField.text
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false

        user.signUpInBackground {
          (succeeded: Bool, error: Error?) -> Void in
            self.view.isUserInteractionEnabled = true
            activityIndicator.stopAnimating()
            var errorText = "Unknown error. Please try again!"
            if let error = error {
              errorText = error.localizedDescription
              self.displayAlert(title: "Try again", message: errorText)
          } else {
              self.performSegue(withIdentifier: "showUserTable", sender: self)
          }
        }
    }
}
