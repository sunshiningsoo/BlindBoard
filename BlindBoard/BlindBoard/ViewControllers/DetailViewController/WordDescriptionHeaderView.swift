//
//  WordTestHeaderView.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/09/23.
//

import UIKit

class WordDescriptionHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    
    var viewModel: WordDescriptionHeaderViewModel? {
        didSet {
            configure()
        }
    }
    
    private let titleTest: UILabel = {
        let label = UILabel()
        label.text = "test"
        return label
    }()
    
    static let headerIdentifier: String = "WordTestHeaderView"

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure() {
        contentView.backgroundColor = .red
        guard let viewModel = viewModel else { return }
        titleTest.text = viewModel.title
        self.addSubview(titleTest)
        titleTest.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 0, paddingLeft: 30)
    }
    
}
