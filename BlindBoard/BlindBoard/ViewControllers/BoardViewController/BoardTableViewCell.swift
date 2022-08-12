//
//  BoardTableViewCell.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/08/12.
//

import UIKit

class BoardTableViewCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        return title
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
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
        self.addSubview(titleLabel)
        titleLabel.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, paddingTop: 30, paddingLeft: 30, paddingBottom: 30)
    }
    
    func set(_ label: Number) {
        titleLabel.text = label.name
    }
    

}
