//
//  BoardTableViewCell.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/08/12.
//

import UIKit

class BoardTableViewCell: UITableViewCell {
    
    //MARK: - properties
    private let titleLabel: UILabel = {
        let title = UILabel()
        return title
    }()
    
    private let content: UILabel = {
        let content = UILabel()
        content.font = UIFont.preferredFont(forTextStyle: .subheadline)
        content.font = UIFont.systemFont(ofSize: 14)
        return content
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func render() {
        self.addSubview(titleLabel)
        titleLabel.anchor(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 10, paddingLeft: 24, paddingRight: 24)
        
        self.addSubview(content)
        content.anchor(top: titleLabel.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 5, paddingLeft: 24, paddingBottom: 10, paddingRight: 24)
    }
    
    func set(_ label: Board) {
        titleLabel.text = label.title
        content.text = label.content
    }
    

}
