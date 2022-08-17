//
//  Comment.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/08/15.
//

import Foundation

struct Comment: Codable {
    let comment: String
    var commentMadeDate: String = Date().ISO8601Format()
}
