//
//  ViewController.swift
//  Instagram-Clone
//
//  Created by Catherine Shing on 2/28/23.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    var currentUser = PFUser.current()

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            performSegue(withIdentifier: "showUserTable", sender: self)
        }
    }
    
    func displayAlert(title: String, message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    @IBAction func userLogin(_ sender: UIButton) {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false

        PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!) {
          (user: PFUser?, error: Error?) -> Void in
            self.view.isUserInteractionEnabled = true
            activityIndicator.stopAnimating()
          if user != nil {
              self.performSegue(withIdentifier: "showUserTable", sender: self)
          }
            else {
              var errorText = "Unknown error. Please try again!"
              if let error = error {
                  errorText = error.localizedDescription
                  self.displayAlert(title: "Try again", message: errorText)
              }
          }
        }
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        performSegue(withIdentifier: "signupSegue", sender: self)
    }
}
