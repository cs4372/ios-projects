//
//  MessagesViewController.swift
//  ChatApp
//
//  Created by Catherine Shing on 5/7/23.
//

import UIKit
import FirebaseAuth

class MessagesViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonClick))
         navigationItem.leftBarButtonItem = logoutButton
        let sendMessageButton = UIBarButtonItem(title: "Send message", style: .plain, target: self, action: #selector(sendMessageClick))
         navigationItem.rightBarButtonItem = sendMessageButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
    }
    
    @objc func logoutButtonClick() {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out", signOutError)
        }
    }
    
    @objc func sendMessageClick() {
        let usersVC = UsersViewController()
        self.navigationController?.pushViewController(usersVC, animated: true)
    }
}
