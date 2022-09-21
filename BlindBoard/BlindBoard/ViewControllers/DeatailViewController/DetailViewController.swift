//
//  DetailViewController.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/08/13.
//

import UIKit
import FirebaseFirestore

class DetailViewController: UIViewController {
    
    //MARK: - properties
    private var arr: [Comment] = []
    private var board: Board
    
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.text = board.title
        return title
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let title = UILabel()
        title.text = board.content
        return title
    }()
    
    private lazy var commentTableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private lazy var commentButton: UIButton = {
        let comment = UIButton()
        comment.setTitle("Comment", for: .normal)
        comment.addTarget(self, action: #selector(addComment), for: .touchUpInside)
        comment.tintColor = .white
        comment.backgroundColor = .systemBlue
        comment.layer.cornerRadius = 15
        
        return comment
    }()
    
    //MARK: - LifeCycle
    init(board: Board){
        self.board = board
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        commentTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.cellIdentifier)
        fetchComment()
        
        // navigation bar setting
        title = "익명의 글"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Actions
    @objc func addComment() {
        let addCommentViewController = AddCommentViewController(board: board)
        addCommentViewController.commentDelegate = self
        present(addCommentViewController, animated: true)

    }
    
    // MARK: - Helpers
    private func render() {
        view.addSubview(contentView)
        contentView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top:contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 30, paddingLeft: 24, paddingRight: 24)
        
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 24, paddingBottom: 20, paddingRight: 24)
        
        view.addSubview(commentTableView)
        commentTableView.anchor(top: contentView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        
        view.addSubview(commentButton)
        commentButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, height: 50)
        
    }
    
    private func fetchComment() {
        reloadComment { [weak self] board in
            guard let self = self else { return }
            self.board = board
            if board.comments.count == 2 {
                self.arr = [Comment(comment: board.comments.first ?? ""), Comment(comment: board.comments[1])]
            } else {
                self.arr = [Comment(comment: board.comments.first ?? "")]
            }
            DispatchQueue.main.async {
                self.commentTableView.reloadData()
            }
            
        }
    }
    
    func reloadComment(completion: @escaping(Board) -> Void) {
        FirebaseConstant.FIRESTORE.document(board.uid).getDocument(completion: { snapshot, error in
            if let snapshot = snapshot {
                guard let dic = snapshot.data() else { return print("SNAPSHOT ERR") }
                let board = Board(dictionary: dic)
                completion(board)
            }
        })
    }
    
}

//MARK: - tableView delegate
extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.cellIdentifier, for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
        cell.setupCell(comment: arr[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

//MARK: - tableView dataSource
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(arr[indexPath.item].comment)
    }
    
}

// MARK: - CommentSaveDelegate
extension DetailViewController: CommentSaveDelegate {
    func saveComment(_ comment: Comment, uid: String) {
        // TODO: - add Comment struct using
        FirebaseConstant.FIRESTORE.document(uid).getDocument { snapshot, error in
            guard let snapshot = snapshot else { return print("DEBUG: detailview snapshot err") }
            print("DEBUG: \(snapshot.data())")
        }
        
    }
}
