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

class InitialLaunchViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: YoshikoTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    private func setupUI() {
        nameLabel.textColor = FlatWatermelon()
        nameLabel.text = "Welcome to Task Master!"
        nameTextField.placeholderFontScale = 1.5
        nameTextField.font = UIFont(name: "Futura", size: 15)
        nameTextField.placeholderColor = FlatGray()
        nameTextField.textColor = FlatSkyBlue()
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
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
