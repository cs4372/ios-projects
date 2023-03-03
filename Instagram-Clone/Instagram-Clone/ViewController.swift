//
//  ViewController.swift
//  Instagram-Clone
//
//  Created by Catherine Shing on 2/28/23.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signupModeActive = true
    var currentUser = PFUser.current()

    @IBOutlet weak var signupOrLoginBtn: UIButton!
    @IBOutlet weak var switchLoginModeBtn: UIButton!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("currentUser", currentUser)
        if PFUser.current() != nil {
            performSegue(withIdentifier: "showUserTable", sender: self)
        }
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func displayAlert(title: String, message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    @IBAction func signupOrLogin(_ sender: UIButton) {
        if (signupModeActive) {
            if usernameTextField.text != nil && passwordTextField.text != nil {
                let user = PFUser()
                user.username = usernameTextField.text
                user.password = passwordTextField.text
                
                user.signUpInBackground {
                  (succeeded: Bool, error: Error?) -> Void in
                    var errorText = "Unknown error. Please try again!"
                    if let error = error {
                      errorText = error.localizedDescription
                      self.displayAlert(title: "Try again", message: errorText)
                  } else {
                      self.performSegue(withIdentifier: "showUserTable", sender: self)
                  }
                }
            }
        } else {
            PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!) {
              (user: PFUser?, error: Error?) -> Void in
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

        }
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func switchLoginMode(_ sender: UIButton) {
        if (signupModeActive) {
            signupModeActive = false
            signupOrLoginBtn.setTitle("Log in", for: .normal)
            switchLoginModeBtn.setTitle("Sign up", for: .normal)
        } else {
            signupModeActive = true
            signupOrLoginBtn.setTitle("Sign up", for: .normal)
            switchLoginModeBtn.setTitle("Login", for: .normal)
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showUserTable" {
//            print("=====>")
//            let vc = UserTableViewController()
//            present(vc, animated: true, completion: nil)
//
//        }
//    }
}

