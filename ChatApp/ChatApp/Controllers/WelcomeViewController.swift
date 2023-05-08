//
//  WelcomeViewController.swift
//  ChatApp
//
//  Created by Catherine Shing on 5/7/23.
//

import UIKit

class WelcomeViewController: ViewController {
    
    let loginButton = UIButton(type: .system)
    let registerButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        setupButtons()
        setupConstraints()
    }
    
    private func setupButtons() {
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = UIColor.lightGray
        loginButton.addTarget(self, action: #selector(loginButtonClick), for: .touchUpInside)
        
        registerButton.setTitle("Register", for: .normal)
        registerButton.backgroundColor = UIColor.systemMint
        registerButton.addTarget(self, action: #selector(registerButtonClick), for: .touchUpInside)
        
        view.addSubview(loginButton)
        view.addSubview(registerButton)
    }
    
    private func setupConstraints() {
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            loginButton.heightAnchor.constraint(equalToConstant: 50),

            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 0),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc private func loginButtonClick() {
        let loginViewController = LoginViewController()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    @objc private func registerButtonClick() {
        let registerViewController = RegisterViewController()
        navigationController?.pushViewController(registerViewController, animated: true)
    }
}
