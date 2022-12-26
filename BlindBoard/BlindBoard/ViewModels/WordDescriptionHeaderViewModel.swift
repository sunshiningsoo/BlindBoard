//
//  WordTestHeaderViewModel.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/09/23.
//

import Foundation

struct WordDescriptionHeaderViewModel {
    let word: Word
    
    init(board: Word) {
        self.word = board
    }
    
    var title: String {
        return word.title
    }
    
    var content: String {
        return word.content
    }
    
}
