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
    var loggedInUserId: String?
    var messages = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        loadMessages() {}
        loggedInUserId = Auth.auth().currentUser?.uid
        view.backgroundColor = UIColor.lightGray
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonClick))
         navigationItem.leftBarButtonItem = logoutButton
        let sendMessageButton = UIBarButtonItem(title: "Send message", style: .plain, target: self, action: #selector(sendMessageClick))
         navigationItem.rightBarButtonItem = sendMessageButton
    }
    
    private func setupViews() {
        view.addSubview(messageTableView)
        
        NSLayoutConstraint.activate([
            messageTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            messageTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private lazy var messageTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.gray
        tableView.register(MessageCell.self, forCellReuseIdentifier: "messageCell")
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        loadMessages { [weak self] in
            DispatchQueue.main.async {
                self?.messageTableView.reloadData()
            }
        }
        print("inside will appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.messageTableView.reloadData()
        }
        print("inside did appear")
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
    
    func getUserName(userId: String, completion: @escaping (String?, String?) -> Void) {
        let usersCollection = db.collection("users")
        let userDocRef = usersCollection.document(userId)
        userDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let firstName = data?["firstName"] as? String
                let lastName = data?["lastName"] as? String
                completion(firstName, lastName)
            } else {
                completion(nil, nil)
            }
        }
    }
        
    var groupedMessages: [String: [Message]] = [:]
    
    func loadMessages(completion: @escaping () -> Void) {
        db.collection("messages")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener {(querySnapshot, err) in
                if let err = err {
                    print("Error getting documents inside ChatView: \(err)")
                } else {
                    self.messages = []
                    self.groupedMessages = [:]
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            print("data", data)
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
                            continue
                        }
                    }
                    self.messages = self.messages.sorted { $0.timestamp > $1.timestamp }
                    DispatchQueue.main.async {
                        self.messageTableView.reloadData()
                        let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                        self.messageTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
                    completion()
            }
        }
    }
}

extension MessagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("messages.count", messages.count)
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
           let message = messages[indexPath.row]
           cell.messageLabel.text = message.body
        let otherUserId = message.senderId == loggedInUserId ? message.receiverId : message.senderId
        var fullName = ""
          getUserName(userId: otherUserId) { firstName, lastName in
            if let firstName = firstName, let lastName = lastName {
                print("firstName inside", firstName)
                fullName = "\(firstName) \(lastName)"
            }
            cell.nameLabel.text = fullName
        }
        print("fullName ==>", fullName)
        cell.messageLabel.text = message.body
           cell.backgroundColor = UIColor.white
           return cell
    }
}

extension MessagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

