//
//  NewMessageViewController.swift
//  ChatApp
//
//  Created by Catherine Shing on 5/7/23.
//

import UIKit
import FirebaseFirestore

class NewMessageViewController: UIViewController {
    
    private let tableView = UITableView()
    private var users: [User] = []
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
                
        // Add constraints
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        fetchUsers()
    }
    
    private func fetchUsers() {
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let id = data["id"] as? String,
                           let firstName = data["firstName"] as? String,
                           let lastName = data["lastName"] as? String,
                           let email = data["email"] as? String {
                            self.users.append(User(id: id, firstName: firstName, lastName: lastName, email: email))
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
}

extension NewMessageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user = users[indexPath.row]
        cell.backgroundColor = UIColor.lightGray
        cell.selectionStyle = .none
        cell.textLabel?.text = user.firstName
        return cell
    }
}

extension NewMessageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}
