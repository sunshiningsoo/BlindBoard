//
//  Board.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/08/15.
//

import Foundation

struct Board: Codable {
    let title: String
    let content: String
    let uid: String
    let imageUrl: String
    
    init(title: String, content: String, uid: String, imageUrl: String) {
        self.title = title
        self.content = content
        self.uid = uid
        self.imageUrl = imageUrl
    }
    
    init(dictionary: [String: Any]) {
        self.title = dictionary["testTitle"] as? String ?? ""
        self.content = dictionary["textContent"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
}
