//
//  Hotel.swift
//  Bucket-List-Hotels
//
//  Created by Catherine Shing on 1/4/23.
//

import UIKit

struct Hotel: Decodable, Hashable {
    var id: Int32
    var name: String
    var address: String
    var country: String
    var phone: String
    var description: String
    var stars: String
    var image: String
    
    
    init(id: Int32, name: String, address: String, country: String, phone: String, description: String, stars: String, image: String) {
        self.id = id
        self.name = name
        self.address = address
        self.country = country
        self.phone = phone
        self.description = description
        self.stars = stars
        self.image = image
    }
    
    init() {
        self.init(id: 0, name: "", address: "", country: "", phone: "", description: "", stars: "", image: "")
    }
}
