//
//  AddCommentViewController.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/09/21.
//

import UIKit
import FirebaseFirestore

protocol CommentSaveDelegate {
    func saveComment(_ comment: Comment, uid: String)
}

class AddCommentViewController: UIViewController {

    // MARK: - Properties
    var commentDelegate: CommentSaveDelegate?
    private let comment = CustomTextField(placeholder: "put comment here")
    var board: Board
    
    private lazy var saveButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(saveComment), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycle
    
    init(board: Board) {
        self.board = board
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }
    
    // MARK: - Actions
    @objc func saveComment() {
        commentDelegate?.saveComment(Comment(comment: comment.text ?? ""), uid: board.uid)
        self.dismiss(animated: true)
    }
    
    // MARK: - Helpers
    
    private func configure() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(comment)
        comment.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 24, paddingRight: 24, height: 50)
        
        view.addSubview(saveButton)
        saveButton.anchor(top: comment.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 100, paddingLeft: 24, paddingRight: 24, height: 50)
    }

}
