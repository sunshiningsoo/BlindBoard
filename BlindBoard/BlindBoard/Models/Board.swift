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
    
    init(title: String, content: String, uid: String) {
        self.title = title
        self.content = content
        self.uid = uid
    }
    
    init(dictionary: [String: Any]) {
        self.title = dictionary["testTitle"] as? String ?? ""
        self.content = dictionary["textContent"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
