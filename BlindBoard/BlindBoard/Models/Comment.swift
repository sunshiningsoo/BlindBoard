//
//  Comment.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/08/15.
//

import Foundation

struct Comment: Codable {
    var comment: String = "testcomment"
    var commentMadeDate: String = Date().ISO8601Format()
    
    init(comment: String) {
        self.comment = comment
    }
    
    init(dictionary: [String: Any]) {
        self.comment = dictionary["comment"] as? String ?? ""
        self.commentMadeDate = dictionary["commentMadeDate"] as? String ?? ""
    }
}
