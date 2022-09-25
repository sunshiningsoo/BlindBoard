//
//  BoardViewModel.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/09/25.
//

import Foundation

struct BoardViewModel {
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
