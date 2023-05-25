//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by Catherine Shing on 5/7/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: Constants.BrandColors.blue)
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        setupViews()
        setupConstraints()
        configureBackground()
        addDismissKeyboardGesture()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTextField:
            lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            textField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         
         backgroundImageView.removeFromSuperview()
     }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.rectangle")
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var selectImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select your profile picture", for: .normal)
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(handleSelectImage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "First Name"
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor(named: Constants.BrandColors.blue)?.cgColor
        textField.layer.borderWidth = 2
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Last Name"
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor(named: Constants.BrandColors.blue)?.cgColor
        textField.layer.borderWidth = 2
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor(named: Constants.BrandColors.blue)?.cgColor
        textField.layer.borderWidth = 2
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor(named: Constants.BrandColors.blue)?.cgColor
        textField.layer.borderWidth = 2
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.addTarget(self, action: #selector(registerButtonClick), for: .touchUpInside)
        button.backgroundColor = UIColor(named: Constants.BrandColors.grey)
        button.setTitleColor(UIColor(named: Constants.BrandColors.backgroundColor), for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView(image: UIImage(named: "AppIcon"))
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.alpha = 0.1
        return backgroundImageView
    }()
    
    private func addDismissKeyboardGesture() {
          let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
          tapGesture.cancelsTouchesInView = false
          view.addGestureRecognizer(tapGesture)
    }
      
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func configureBackground() {
        view.backgroundColor = UIColor(named: Constants.BrandColors.backgroundColor)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupViews() {
        view.addSubview(profileImageView)
        view.addSubview(selectImageButton)
        view.addSubview(firstNameTextField)
        view.addSubview(lastNameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)
        view.addSubview(backgroundImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 200),
            profileImageView.widthAnchor.constraint(equalToConstant: 200),

            selectImageButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            selectImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            firstNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstNameTextField.topAnchor.constraint(equalTo: selectImageButton.bottomAnchor, constant: 30),
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
    
    @objc private func registerButtonClick() {
        guard let firstName = firstNameTextField.text,
              let lastName = lastNameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in            
            if let error = error {
                self.handleError(error)
                return
            }
            
            if let user = authResult?.user {
                let userId = user.uid
                
                let storageRef = Storage.storage().reference()
                let userRef = storageRef.child("profile_images").child("\(userId).jpg")

                if let image = self.profileImageView.image, let imageData = image.pngData() {
                    userRef.putData(imageData, metadata: nil) { metadata, error in
                        if let error = error {
                            print("Error uploading user data: \(error)")
                            return
                        }
                        
                        if let _ = metadata {
                            userRef.downloadURL { url, error in
                                if let error = error {
                                    print("Error retrieving download URL: \(error)")
                                    return
                                }
                                
                                if let profileImageUrl = url?.absoluteString {
                                    print("Profile image URL: \(profileImageUrl)")
                                    
                                    let userData = [
                                        "id": userId,
                                        "firstName": firstName,
                                        "lastName": lastName,
                                        "email": email,
                                        "profileImageUrl": profileImageUrl
                                    ]
                                    
                                    let db = Firestore.firestore()
                                    let userRef = db.collection("users").document(userId)
                                    
                                    userRef.setData(userData) { error in
                                        if let error = error {
                                            print("Error writing user data: \(error)")
                                            return
                                        }
                                        
                                        let messagesVC = MessagesViewController()
                                        self.navigationController?.pushViewController(messagesVC, animated: true)
                                    }
                                }
                                print("Successfully uploaded to Firebase Storage.")
                            }
                        }
                    }
                }
            }
        }
    }
}
