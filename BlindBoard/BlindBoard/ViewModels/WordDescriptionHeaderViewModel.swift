//
//  WordTestHeaderViewModel.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/09/23.
//

import Foundation

struct WordDescriptionHeaderViewModel {
    let board: Board
    
    init(board: Board) {
        self.board = board
    }
    
    var title: String {
        return board.title
    }
    
    var content: String {
        return board.content
    }
    
}
