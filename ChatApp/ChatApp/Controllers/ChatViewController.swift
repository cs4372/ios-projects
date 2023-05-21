//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Catherine Shing on 5/8/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ChatViewController: UIViewController {
        
    private let db = Firestore.firestore()
    var messages = [Message]()
    var receiverFirstName: String?
    var receiverProfileImageUrl: String?
    var receiverId: String?
    var senderId: String?
    var loggedInUserId: String?
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.rectangle")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
        
    private lazy var messageTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(ChatCell.self, forCellReuseIdentifier: "chatCell")
        return tableView
    }()
    
    private lazy var messageTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Type your message here..."
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
                
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        loggedInUserId = Auth.auth().currentUser?.uid
        setupViews()
        loadMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let firstName = receiverFirstName, let imageURL = receiverProfileImageUrl {
            navigationItem.title = firstName
            navigationController?.navigationBar.prefersLargeTitles = false
        }
        messageTableView.reloadData()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.white
        view.addSubview(messageTableView)
        view.addSubview(messageTextField)
        view.addSubview(sendButton)
        NSLayoutConstraint.activate([
            messageTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            messageTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageTableView.bottomAnchor.constraint(equalTo: messageTextField.topAnchor),
            messageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
            messageTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            messageTextField.widthAnchor.constraint(equalToConstant: 280),
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
                    print("Error getting documents inside ChatViewVC \(err)")
                    return
                }
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageId = data["id"] as? String, let messageSender = data["senderId"] as? String, let receiverId = data["receiverId"] as? String, let messageBody = data["body"] as? String, let timestamp = data["timestamp"] as? TimeInterval {
                            let newMessage = Message(id: messageId, senderId: messageSender, receiverId: receiverId, body: messageBody, timestamp: timestamp)
                            self.messages.append(newMessage)
                            
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

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatCell
        let message = messages[indexPath.row]
        cell.selectionStyle = .none
        cell.messageLabel.text = message.body

        cell.messageBubbleView.backgroundColor = message.senderId == self.senderId ? UIColor.blue : UIColor.gray
        
        cell.imageView?.contentMode = .scaleAspectFill
        
        if let profileImageUrl = receiverProfileImageUrl {
            cell.profileImageView.loadImageUsingCache(urlString: profileImageUrl)
        }
        
        if message.senderId == Auth.auth().currentUser?.uid {
            cell.messageBubbleView.backgroundColor = UIColor(named: Constants.BrandColors.blue)
            cell.messageBubbleViewRightConstraint.isActive = true
            cell.profileImageViewRightConstraint.isActive = true
            cell.messageBubbleViewLeftConstraint.isActive = false
            cell.profileImageViewLeftConstraint.isActive = false
        } else {
            cell.messageBubbleView.backgroundColor = UIColor(named: Constants.BrandColors.grey)
            cell.messageBubbleViewRightConstraint.isActive = false
            cell.profileImageViewRightConstraint.isActive = false
            cell.messageBubbleViewLeftConstraint.isActive = true
            cell.profileImageViewLeftConstraint.isActive = true
        }
        return cell
    }
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = messages[indexPath.row]
        let messageText = message.body
        
        let labelWidth: CGFloat = 200
        let labelFont = UIFont.systemFont(ofSize: 17)
        let labelSize = CGSize(width: labelWidth, height: .greatestFiniteMagnitude)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        let estimatedHeight = NSString(string: messageText).boundingRect(with: labelSize, options: options, attributes: [NSAttributedString.Key.font: labelFont], context: nil).height
        
        let extraHeight: CGFloat = 30
        
        return estimatedHeight + extraHeight
    }
}
