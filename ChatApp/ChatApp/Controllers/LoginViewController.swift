//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Catherine Shing on 5/7/23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemTeal
        
        setupTextFields()
        setupLoginButton()
        setupConstraints()
    }
    
    private func setupTextFields() {
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.text = "ty@test.com"
        view.addSubview(emailTextField)
        
        passwordTextField.placeholder = "Password"
        passwordTextField.text = "123456"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        view.addSubview(passwordTextField)
    }
    
    private func setupLoginButton() {
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonClick), for: .touchUpInside)
        view.addSubview(loginButton)
    }
    
    private func setupConstraints() {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            emailTextField.widthAnchor.constraint(equalToConstant: 250),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalToConstant: 250),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.widthAnchor.constraint(equalToConstant: 100),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func loginButtonClick() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    print("error", error)
                } else {
                    let messagesVC = MessagesViewController()
                    self.navigationController?.pushViewController(messagesVC, animated: true)
                }
            }
        }
    }
}
