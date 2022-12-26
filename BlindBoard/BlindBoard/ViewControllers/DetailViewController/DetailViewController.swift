//
//  DetailViewController.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/08/13.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import SDWebImage

class DetailViewController: UIViewController {
    
    //MARK: - Properties
        
    private var arr: [Comment] = []
    
    private var board: Word
    
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
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    //MARK: - LifeCycle
    
    init(board: Word){
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
        navigationItemSetting()
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
    
    @objc func deleteWord() {
        let alert = UIAlertController(title: "\(board.title) 삭제", message: "해당 단어를 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "삭제", style: .default, handler: { action in
            self.showLoader(true)
            FirebaseConstant.COLLECTION_BOARD.document(self.board.uid).delete()
            Storage.storage().reference(withPath: "/\(SceneDelegate.uid ?? "error")/\(self.board.imageFileName)").delete { error in
                if let error = error {
                    print("delete에서 에러발생 \(error.localizedDescription)")
                } else {
                    self.showLoader(false)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }))
        present(alert, animated: true)
    }
    
    // MARK: - Helpers
    
    private func render() {
        view.addSubview(commentTableView)
        commentTableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        view.addSubview(commentButton)
        commentButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, height: 50)
        
        imageViewUI.sd_setImage(with: URL(string: board.imageUrl))
        view.addSubview(imageViewUI)
        imageViewUI.anchor(bottom: commentButton.topAnchor, paddingBottom: 200, width: 300, height: 300)
        imageViewUI.centerX(inView: view)
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
    
    func navigationItemSetting() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .done, target: self, action: #selector(deleteWord))
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
        if headerView.viewModel == nil {
            // TODO: - 이 함수가 왜 여러번 불리는지 이유는 모르겠음
            // headerview의 viewModel이 계속해서 업데이트 되는 것을 막아줌
            // 이렇게 해두면, viewModel이 업데이트 되었을 때, 대응하지 못함 -> 구조를 바꿔주어야함
            // arr didSet 안해주니까 계속 업데이트 되지는 않음
            headerView.viewModel = WordDescriptionHeaderViewModel(board: self.board)
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let width = view.frame.width
        let height = width / 3
        return CGFloat(height)
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

