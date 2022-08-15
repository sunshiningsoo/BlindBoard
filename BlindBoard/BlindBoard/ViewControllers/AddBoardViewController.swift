//
//  AddBoardViewController.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/08/12.
//

import UIKit

protocol AddDelegate {
    func addContent(number: Number)
}

class AddBoardViewController: UIViewController {
    var delegate: AddDelegate?
    
    private lazy var save: UIButton = {
        let save = UIButton()
        save.setTitle("Save", for: .normal)
        save.tintColor = .white
        save.backgroundColor = .systemBlue
        save.addTarget(self, action: #selector(saveBoard), for: .touchUpInside)
        return save
    }()
    
    private let contentTitle: UITextField = {
        let text = UITextField()
        text.placeholder = "Write your Title"
        return text
    }()
    
    private let content: UITextField = {
        let content = UITextField()
        content.placeholder = "write your content"
        return content
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        render()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .systemBackground
    }
    
    @objc
    func saveBoard() {
        delegate?.addContent(number: Number(title: contentTitle.text ?? "no item", content: content.text ?? "no content"))
        self.dismiss(animated: true)
    }
    
    private func render() {
        view.addSubview(contentTitle)
        contentTitle.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 24, paddingRight: 24, height: 50)
        
        view.addSubview(content)
        content.anchor(top: contentTitle.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 24, paddingRight: 24, height: 50)
        
        view.addSubview(save)
        save.anchor(top: content.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 24, paddingRight: 24, height: 50)
    }
    


}
