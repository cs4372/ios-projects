//
//  MessagesViewController.swift
//  ChatApp
//
//  Created by Catherine Shing on 5/7/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class MessagesViewController: UIViewController {
    
    private let db = Firestore.firestore()
    private var loggedInUserId: String?
    private var users: [User] = []
    private var messages = [Message]()
    private var groupedMessages: [String: [Message]] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationBar()
        loggedInUserId = Auth.auth().currentUser?.uid
        loadMessages()
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(named: Constants.BrandColors.backgroundColor)
        view.addSubview(messageTableView)

        NSLayoutConstraint.activate([
            messageTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            messageTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupNavigationBar() {
         let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonClick))
        let sendMessageImage = UIImage(systemName: "square.and.pencil")
        let sendMessageButton = UIBarButtonItem(image: sendMessageImage, style: .plain, target: self, action: #selector(sendMessageClick))
         navigationItem.leftBarButtonItem = logoutButton
         navigationItem.rightBarButtonItem = sendMessageButton
     }
    
    private lazy var messageTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.gray
        tableView.register(MessageCell.self, forCellReuseIdentifier: "messageCell")
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Messages"
        navigationController?.navigationBar.prefersLargeTitles = true
        messageTableView.reloadData()
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        title = ""
        navigationController?.navigationBar.prefersLargeTitles = false
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
            
    func loadMessages() {
        db.collection("messages")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener {(querySnapshot, err) in
                if let err = err {
                    print("Error getting documents inside ChatView: \(err)")
                    return
                }
                self.messages = []
                self.groupedMessages = [:]
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageId = data["id"] as? String, let messageSender = data["senderId"] as? String, let receiverId = data["receiverId"] as? String, let messageBody = data["body"] as? String, let timestamp = data["timestamp"] as? TimeInterval {
                            if messageSender == self.loggedInUserId || receiverId == self.loggedInUserId {
                                
                                let newMessage = Message(id: messageId, senderId: messageSender, receiverId: receiverId, body: messageBody, timestamp: timestamp)
                                let id1 = "\(messageSender)-\(receiverId)"
                                let id2 = "\(receiverId)-\(messageSender)"
                                if let existingMessages = self.groupedMessages[id1] {
                                    self.groupedMessages[id1] = existingMessages + [newMessage]
                                } else if let existingMessages = self.groupedMessages[id2] {
                                    self.groupedMessages[id2] = existingMessages + [newMessage]
                                } else {
                                    self.groupedMessages[id1] = [newMessage]
                                }
                            }
                        }
                    }
                }

                for (_, items) in self.groupedMessages {
                    if let firstMessage = items.first {
                        self.messages.append(firstMessage)
                    }
                }
                self.messages = self.messages.sorted { $0.timestamp > $1.timestamp }
                
                DispatchQueue.main.async {
                    self.messageTableView.reloadData()
            
            }
        }
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

extension MessagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
                
        cell.messageLabel.text = message.body
        let otherUserId = message.senderId == loggedInUserId ? message.receiverId : message.senderId
        var fullName = ""
        getUserData(userId: otherUserId) { firstName, lastName, profileImageUrl in
            if let firstName = firstName, let lastName = lastName {
                fullName = "\(firstName) \(lastName)"
            }
            if let profileImageUrl = profileImageUrl {
                cell.profileImageView.loadImageUsingCache(urlString: profileImageUrl)
            }
            cell.nameLabel.text = fullName
            cell.timestampLabel.text = DateUtils.convertTimestampToString(timestamp: message.timestamp)
        }
        cell.messageLabel.text = message.body
        return cell
    }
}

extension MessagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        let ChatVC = ChatViewController()
        let otherUserId = message.senderId == loggedInUserId ? message.receiverId : message.senderId
        ChatVC.receiverId = otherUserId
        
        getUserData(userId: otherUserId) { firstName, lastName, selectedProfileImageUrl in
            if let firstName = firstName {
                ChatVC.receiverFirstName = firstName
                ChatVC.receiverProfileImageUrl = selectedProfileImageUrl
            }
            
            let group = DispatchGroup()
            
            if let loggedInUserId = self.loggedInUserId {
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
}
