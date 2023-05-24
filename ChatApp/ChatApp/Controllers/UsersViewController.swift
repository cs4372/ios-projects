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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Users"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        title = ""
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor(named: Constants.BrandColors.backgroundColor)
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
    
    func getUserData(userId: String, completion: @escaping (String?, String?, String?) -> Void) {
        let usersCollection = db.collection("users")
        let userDocRef = usersCollection.document(userId)
        userDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let firstName = data?["firstName"] as? String
                let lastName = data?["lastName"] as? String
                let profileImageUrl = data?["profileImageUrl"] as? String
                completion(firstName, lastName, profileImageUrl)
            } else {
                completion(nil, nil, nil)
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
    
    func getProfileImageUrl(for userId: String, completion: @escaping (String?) -> Void) {
        let userRef = Firestore.firestore().collection("users").document(userId)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let userData = document.data()
                let profileImageUrl = userData?["profileImageUrl"] as? String
                completion(profileImageUrl)
            } else {
                completion(nil)
            }
        }
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
        ChatVC.receiverProfileImageUrl = user.profileImageUrl

        let group = DispatchGroup()
        
        if let loggedInUserId = Auth.auth().currentUser?.uid {
            group.enter()
            self.getProfileImageUrl(for: loggedInUserId) { profileImageUrl in
                if let profileImageUrl = profileImageUrl {
                    ChatVC.currentUserProfileImageUrl = profileImageUrl
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.navigationController?.pushViewController(ChatVC, animated: true)
        }
    }
}
