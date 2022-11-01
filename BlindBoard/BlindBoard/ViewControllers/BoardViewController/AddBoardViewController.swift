//
//  AddBoardViewController.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/08/12.
//

import UIKit

protocol AddDelegate {
    func addContent(board: Board)
}

class AddBoardViewController: UIViewController {
    
    
    // MARK: - Properties
    
    var delegate: AddDelegate?
    
    private lazy var save: UIButton = {
        let save = UIButton()
        save.setTitle("Save", for: .normal)
        save.tintColor = .white
        save.backgroundColor = .systemBlue
        save.layer.cornerRadius = 5
        save.addTarget(self, action: #selector(saveBoard), for: .touchUpInside)
        return save
    }()
    
    private let contentTitle: UITextField = {
        let text = UITextField()
        text.placeholder = "Write your Title"
        text.clearButtonMode = .whileEditing
        text.addLeftPadding()
        return text
    }()
    
    private let content: UITextField = {
        let content = UITextField()
        content.placeholder = "write your content"
        content.clearButtonMode = .whileEditing
        content.addLeftPadding()
        return content
    }()

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        contentTitle.text = ""
        content.text = ""
    }
    
    // MARK: - Actions
    
    @objc func saveBoard() {
        if contentTitle.text == "" || content.text == "" {
            let alert = UIAlertController(title: "No content!", message: "You have to fill the content", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
        } else {
            showLoader(true)
            delegate?.addContent(board: Board(title: contentTitle.text ?? "no item", content: content.text ?? "no content", uid: UUID().uuidString, imageUrl: "", imageFileName: ""))
        }
        
    }
    
    // MARK: - Helpers
    
    private func render() {
        view.addSubview(contentTitle)
        contentTitle.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 24, paddingRight: 24, height: 50)
        
        view.addSubview(content)
        content.anchor(top: contentTitle.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 24, paddingRight: 24, height: 50)
        
        view.addSubview(save)
        save.anchor(top: content.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 24, paddingRight: 24, height: 50)
    }
 
}
