//
//  BoardHeaderViewController.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/09/22.
//

import UIKit

class BoardHeaderViewController: UITableViewHeaderFooterView {

    // MARK: - Properties
    
    static let cellIdentifier = "BoardHeaderViewController"
    
    let customView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    // MARK: - LifeCycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .red
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        contentView.backgroundColor = .lightGray
    }
    
}
