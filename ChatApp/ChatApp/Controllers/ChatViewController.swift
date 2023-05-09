//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Catherine Shing on 5/8/23.
//

import UIKit

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ChatViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate {
        
    private let db = Firestore.firestore()
    private var messages = [Message]()
    var receiverFirstName: String?
    var receiverId: String?
    var senderId: String?
    var loggedInUserId: String?
        
    private lazy var messageTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(MessageCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private lazy var messageTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Type your message here..."
        textField.delegate = self
        textField.returnKeyType = .send
        return textField
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(sendMessageClick), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray
        
        loggedInUserId = Auth.auth().currentUser?.uid
        setupViews()
        loadMessages()
    }
    
    private func setupViews() {
        navigationItem.title = "Chat"
        view.addSubview(messageTableView)
        view.addSubview(messageTextField)
        view.addSubview(sendButton)
        NSLayoutConstraint.activate([
            messageTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            messageTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageTableView.bottomAnchor.constraint(equalTo: messageTextField.topAnchor),
            messageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -16),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sendButton.centerYAnchor.constraint(equalTo: messageTextField.centerYAnchor)
        ])
    }
        
    @objc private func sendMessageClick() {
        if let messageText = messageTextField.text,
           let receiverId = receiverId, let senderId = Auth.auth().currentUser?.uid {
            let messageId = db.collection("messages").document().documentID
            
            db.collection("messages").addDocument(data: [
                "id": messageId,
                "senderId": Auth.auth().currentUser?.uid,
                "receiverId": receiverId,
                "body": messageText,
                "timestamp": Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("There was an issue saving data to Firestore, \(e)")
                } else {
                    print("Successfully saved data.")
                }
            }
          DispatchQueue.main.async {
              self.messageTextField.text = ""
          }
            self.loadMessages()
        }
    }
    
    func loadMessages() {
        db.collection("messages")
            .whereField("senderId", in: [loggedInUserId, receiverId])
            .whereField("receiverId", in: [loggedInUserId, receiverId])
            .order(by: "timestamp")
            .addSnapshotListener {(querySnapshot, err) in
                self.messages = []
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let messageId = data["id"] as? String, let messageSender = data["senderId"] as? String, let receiverId = data["receiverId"] as? String, let messageBody = data["body"] as? String {
                                let newMessage = Message(id: messageId, senderId: messageSender, receiverId: receiverId, body: messageBody)
                                self.messages.append(newMessage)
                                print("self.messages", self.messages)
                                
                                DispatchQueue.main.async {
                                    self.messageTableView.reloadData()
                                    let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                                    self.messageTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
//        cell.backgroundColor = UIColor.lightGray
        cell.selectionStyle = .none
        cell.textLabel?.text = message.body
        
        cell.messageBubbleView.backgroundColor = message.senderId == self.senderId ? UIColor.blue : UIColor.gray
        
        // add constraints to align bubble to the right or left edge of the cell
        if message.senderId == Auth.auth().currentUser?.uid {
            print("inside")
            cell.backgroundColor = UIColor.blue
            cell.messageBubbleViewRightConstraint.isActive = true
            cell.messageBubbleViewLeftConstraint.isActive = false
        } else {
            cell.backgroundColor = UIColor.lightGray
            cell.messageBubbleViewRightConstraint.isActive = false
            cell.messageBubbleViewLeftConstraint.isActive = true
        }
            
        return cell
    }
}
