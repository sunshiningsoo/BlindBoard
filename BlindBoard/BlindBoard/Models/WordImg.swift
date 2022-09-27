//
//  WordImg.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/09/26.
//

import Foundation

struct Img: Codable {
    var page: Int?
    var photos: [ImgInfo]?
}

struct ImgInfo: Codable {
    var src: ImgReal?
}

struct ImgReal: Codable {
    var original: String
}
