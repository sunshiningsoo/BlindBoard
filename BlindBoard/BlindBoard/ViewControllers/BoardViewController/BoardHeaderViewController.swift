//
//  BoardHeaderViewController.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/09/22.
//

import UIKit

protocol TestStart {
    func testStart()
}

class BoardHeaderViewController: UITableViewHeaderFooterView {

    // MARK: - Properties
    
    static let cellIdentifier = "BoardHeaderViewController"
    
    var delegate: TestStart?
    
    private lazy var testButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("테스트 하러가기", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.addTarget(self, action: #selector(testGo), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func testGo() {
        delegate?.testStart()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        contentView.backgroundColor = .systemBackground
        
        self.addSubview(testButton)
        testButton.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 30, paddingLeft: 30, paddingBottom: 30, paddingRight: 30)
    }
    
}
