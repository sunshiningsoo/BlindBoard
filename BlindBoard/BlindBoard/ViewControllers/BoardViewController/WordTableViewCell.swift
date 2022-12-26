//
//  BoardTableViewCell.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/08/12.
//

import UIKit

class WordTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let cellIdentifier = String(describing: WordTableViewCell.self)
    
    var viewModel: WordViewModel? {
        didSet {
            configure()
        }
    }
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 30)
        return title
    }()
    
    private let content: UILabel = {
        let content = UILabel()
        content.font = UIFont.preferredFont(forTextStyle: .subheadline)
        content.font = UIFont.systemFont(ofSize: 20)
        return content
    }()
    
    //MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func render() {
        self.addSubview(titleLabel)
        titleLabel.anchor(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 10, paddingLeft: 24, paddingRight: 24)
        
        self.addSubview(content)
        content.anchor(top: titleLabel.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 5, paddingLeft: 24, paddingBottom: 10, paddingRight: 24)
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        titleLabel.text = viewModel.title
        content.text = viewModel.content
    }

}
