//
//  Hotel.swift
//  Bucket-List-Hotels
//
//  Created by Catherine Shing on 1/4/23.
//

import UIKit

struct Hotel: Hashable {
    var name: String
    var address: String
    var country: String
    var phone: String
    var description: String
    var stars: String
    var image: String
    
    
    init(name: String, address: String, country: String, phone: String, description: String, stars: String, image: String) {
        self.name = name
        self.address = address
        self.country = country
        self.phone = phone
        self.description = description
        self.stars = stars
        self.image = image
    }
    
    init() {
        self.init(name: "", address: "", country: "", phone: "", description: "", stars: "", image: "")
    }
}
