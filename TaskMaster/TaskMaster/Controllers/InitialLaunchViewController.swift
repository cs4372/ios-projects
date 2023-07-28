//
//  InitialLaunchViewController.swift
//  TaskMaster
//
//  Created by Catherine Shing on 6/8/23.
//

import UIKit
import CLTypingLabel
import TextFieldEffects
import ChameleonFramework

class InitialLaunchViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTapGesture()
        nameTextField.delegate = self
    }
    
    private func setupUI() {
        nameLabel.textColor = FlatWatermelon()
        nameLabel.text = "Welcome to Task Master!"
        nameTextField.font = UIFont(name: "Futura", size: 15)
        nameTextField.placeholder = "Enter your name..."
        nameTextField.textColor = FlatSkyBlue()
        nameTextField.font = UIFont.systemFont(ofSize: 20)
        nameTextField.autocapitalizationType = .sentences
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        view.endEditing(true)
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        saveUserNameAndNavigate()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveUserNameAndNavigate()
        return true
    }
    
    private func saveUserNameAndNavigate() {
        guard let name = nameTextField.text, !name.isEmpty else {
            return
        }
        
        UserDefaults.standard.set(name, forKey: "UserName")
        navigateToTaskViewController()
    }
    
    private func navigateToTaskViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        tabBarController.selectedIndex = 0
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = tabBarController
        }
    }
}
