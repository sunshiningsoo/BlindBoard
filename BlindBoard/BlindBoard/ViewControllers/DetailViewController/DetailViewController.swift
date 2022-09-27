//
//  DetailViewController.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/08/13.
//

import UIKit
import FirebaseFirestore

class DetailViewController: UIViewController {
    
    //MARK: - Properties
        
    private var arr: [Comment] = [] {
        didSet {
            fetchComment()
        }
    }
    
    private var board: Board
    
    private lazy var commentTableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        return table
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
    
    private var imageViewUI: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
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
        commentTableView.register(WordDescriptionHeaderView.self, forHeaderFooterViewReuseIdentifier: WordDescriptionHeaderView.headerIdentifier)
        fetchComment()
        ImageService.imagesFetch(word: board.title) { image in
            self.imageViewUI.image = image
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .systemBackground
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        imageViewUI.image = UIImage()
    }
    
    // MARK: - Actions
    
    @objc func addComment() {
        let addCommentViewController = AddCommentViewController(board: board)
        addCommentViewController.commentDelegate = self
        present(addCommentViewController, animated: true)

    }
    
    // MARK: - Helpers
    
    private func render() {
        view.addSubview(commentTableView)
        commentTableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        view.addSubview(commentButton)
        commentButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, height: 50)
        
        view.addSubview(imageViewUI)
        imageViewUI.anchor(bottom: commentButton.topAnchor, paddingBottom: 100, width: 300, height: 300)
    }
    
    private func fetchComment() {
        reloadComment { [weak self] comments in
            guard let self = self else { return }
            self.arr = comments
            DispatchQueue.main.async {
                self.commentTableView.reloadData()
            }
        }
    }
    
    func reloadComment(completion: @escaping([Comment]) -> Void) {
        FirebaseConstant.COLLECTION_BOARD.document(board.uid).collection("comments").order(by: "commentMadeDate", descending: false).getDocuments { snapshot, error in
            guard let snapshot = snapshot?.documents else { return }
            
            let temp = snapshot.map { Comment(dictionary: $0.data()) }
            completion(temp)
        }
    }
    
}

//MARK: - UITableViewDelegate

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.cellIdentifier, for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
        
        cell.viewModel = CommentCellViewModel(comment: arr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: WordDescriptionHeaderView.headerIdentifier) as? WordDescriptionHeaderView else { return UIView() }
        
        headerView.viewModel = WordDescriptionHeaderViewModel(board: self.board)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(100)
    }
    
}

//MARK: - UITableViewDataSource

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(arr[indexPath.row].comment)
    }
    
}

// MARK: - CommentSaveDelegate

extension DetailViewController: CommentSaveDelegate {
    func saveComment(_ comment: Comment, uid: String) {
        FirebaseConstant.COLLECTION_BOARD.document(uid).collection("comments").addDocument(data: ["comment": comment.comment, "commentMadeDate": comment.commentMadeDate]) { error in
            if let error = error {
                print("DEBUG: SAVE COMMENT ERROR \(error.localizedDescription)")
            }
            self.fetchComment()
        }
    }
    
}

