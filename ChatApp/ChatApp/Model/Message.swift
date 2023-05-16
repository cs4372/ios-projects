//
//  Message.swift
//  ChatApp
//
//  Created by Catherine Shing on 5/8/23.
//

import Foundation

struct Message {
    let id: String
    let senderId: String
    let receiverId: String
    let body: String
    let timestamp: TimeInterval
    
    init(id: String, senderId: String, receiverId: String, body: String, timestamp: TimeInterval) {
        self.id = id
        self.senderId = senderId
        self.receiverId = receiverId
        self.body = body
        self.timestamp = timestamp
    }
    
    func with(body: String) -> Message {
          return Message(id: self.id, senderId: self.senderId, receiverId: self.receiverId, body: body, timestamp: self.timestamp)
      }
}
