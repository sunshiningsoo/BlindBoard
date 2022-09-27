//
//  WordTestHeaderView.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/09/23.
//

import UIKit

class WordDescriptionHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    
    static let headerIdentifier: String = "WordTestHeaderView"
    
    var viewModel: WordDescriptionHeaderViewModel? {
        didSet {
            configure() // ViewModel이 deque되기 때문에, viewModel의 didSet 호출이 많음..
        }
    }
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let content: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    // MARK: - LifeCycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure() {
        contentView.backgroundColor = .systemBlue
        guard let viewModel = viewModel else { return }
        title.text = viewModel.title
        content.text = viewModel.content
        
        self.addSubview(title)
        title.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 0, paddingLeft: 30)
        
        self.addSubview(content)
        content.anchor(top: title.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 20, paddingLeft: 30, paddingRight: 30)
        
    }
    
}
