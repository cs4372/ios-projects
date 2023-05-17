//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by Catherine Shing on 5/7/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class RegisterViewController: UIViewController {
    let firstNameTextField = UITextField()
    let lastNameTextField = UITextField()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    
    let registerButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemTeal
        
        setupTextFields()
        setupRegisterButton()
        setupConstraints()
    }
    
    private func setupTextFields() {
        firstNameTextField.placeholder = "First Name"
        firstNameTextField.borderStyle = .roundedRect
        view.addSubview(firstNameTextField)
        
        lastNameTextField.placeholder = "Last Name"
        lastNameTextField.borderStyle = .roundedRect
        view.addSubview(lastNameTextField)
        
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        view.addSubview(emailTextField)
        
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        view.addSubview(passwordTextField)
    }
    
    private func setupRegisterButton() {
        registerButton.setTitle("Register", for: .normal)
        registerButton.addTarget(self, action: #selector(registerButtonClick), for: .touchUpInside)
        view.addSubview(registerButton)
    }
    
    private func setupConstraints() {
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            firstNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstNameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            firstNameTextField.widthAnchor.constraint(equalToConstant: 250),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            lastNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 20),
            lastNameTextField.widthAnchor.constraint(equalToConstant: 250),
            lastNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 20),
            emailTextField.widthAnchor.constraint(equalToConstant: 250),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalToConstant: 250),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            registerButton.widthAnchor.constraint(equalToConstant: 100),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    @objc func registerButtonClick() {
        if let firstName = firstNameTextField.text, let lastName = lastNameTextField.text, let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
                if let e = error {
                    print(e)
                    return
                }
                guard let user = authResult?.user else {
                    print("Error: User not found.")
                    return
                }
                
                let uuid = Auth.auth().currentUser?.uid
                    
                let db = Firestore.firestore()
                let userRef = db.collection("users").document(uuid!)
                let data = [
                    "id": uuid,
                    "firstName": firstName,
                    "lastName": lastName,
                    "email": email
                ]
                    
                userRef.setData(data) { (error) in
                    if let error = error {
                        print("Error writing user data: \(error)")
                        return
                    }
                    let messagesVC = MessagesViewController()
                    self.navigationController?.pushViewController(messagesVC, animated: true)
                }
            }
        }
    }
}
