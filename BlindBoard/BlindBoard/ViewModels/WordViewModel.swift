//
//  BoardViewModel.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/09/25.
//

import Foundation

struct WordViewModel {
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
