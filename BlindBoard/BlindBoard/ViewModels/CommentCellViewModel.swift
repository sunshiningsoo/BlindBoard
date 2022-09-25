//
//  CommentCellViewModel.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/09/26.
//

import Foundation

struct CommentCellViewModel {
    var comment: Comment
    
    init(comment: Comment) {
        self.comment = comment
    }
    
    var commentContent: String {
        return comment.comment
    }
    
    var commentMadeDate: String {
        return comment.commentMadeDate
    }
    
}
