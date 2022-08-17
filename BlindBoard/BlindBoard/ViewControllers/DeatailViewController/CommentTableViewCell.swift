//
//  CommentTableViewCell.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/08/13.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "CommentTableViewCell"
    
    private let commentLabel: UILabel = {
        let comment = UILabel()
        comment.numberOfLines = 0
        return comment
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func render() {
        self.addSubview(commentLabel)
        commentLabel.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 10, paddingLeft: 24, paddingBottom: 10, paddingRight: 24)
    }
    
    func setupCell(comment: Comment) {
        self.backgroundColor = .systemBackground
        commentLabel.text = comment.comment
        
    }

}
