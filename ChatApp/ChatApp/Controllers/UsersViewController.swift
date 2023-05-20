//
//  UsersViewController.swift
//  ChatApp
//
//  Created by Catherine Shing on 5/7/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class UsersViewController: UIViewController {
    
    private let tableView = UITableView()
    private var users: [User] = []
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        fetchUsers()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserCell.self, forCellReuseIdentifier: "userCell")
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func fetchUsers() {
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            }
            if let snapshotDocuments = querySnapshot?.documents {
                for doc in snapshotDocuments {
                    let data = doc.data()
                    if let id = data["id"] as? String,
                       let firstName = data["firstName"] as? String,
                       let lastName = data["lastName"] as? String,
                       let email = data["email"] as? String,
                       let profileImageUrl = data["profileImageUrl"] as? String,
                       id != Auth.auth().currentUser?.uid
                    {
                        let user = User(id: id, firstName: firstName, lastName: lastName, email: email, profileImageUrl: profileImageUrl)
                        self.users.append(user)
                    }
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension UsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.nameLabel.text = user.firstName
        
        cell.imageView?.contentMode = .scaleAspectFill
        
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCache(urlString: profileImageUrl)
        }

        return cell
    }
}

extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let ChatVC = ChatViewController()
        ChatVC.receiverId = user.id
        ChatVC.receiverFirstName = user.firstName
        navigationController?.pushViewController(ChatVC, animated: true)
    }
}
