//
//  DetailViewController.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/08/13.
//

import UIKit
import FirebaseFirestore

class DetailViewController: UIViewController {
    
    private let arr: [Comment] = []
    
//    Comment(comment: "너의 의견에 동의하는바야"), Comment(comment: "너의 의견에 동의하는바야너의 의견에 동의하는바야너의 의견에 동의하는바야너의 의견에 동의하는바야너의 의견에 동의하는바야너의 의견에 동의하는바야")
    
    let db = Firestore.firestore()
    
    //MARK: - properties
    private var number: Board?
    
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.text = number?.title
        return title
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let title = UILabel()
        title.text = number?.content
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
        return comment
    }()
    @objc
    func addComment() {
        db.collection(FirebaseConstant.collectiontemp).document(<#T##documentPath: String##String#>)
    }
    
    //MARK: - init
    init(number: Board){
        super.init(nibName: nil, bundle: nil)
        self.number = number
        reloadComment()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        commentTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.cellIdentifier)
        
        // navigation bar setting
        title = "익명의 글"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .systemBackground
    }
    
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
        commentButton.anchor(top: commentTableView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 24, paddingRight: 24)
    }
    
    private func reloadComment() {
        db.collection(FirebaseConstant.collectiontemp).document(number!.title).addSnapshotListener { snapshot, error in
            guard let error = error else { return print("\(error?.localizedDescription)") }
            guard let snapshot = snapshot else { return print("Snapshot err! \(snapshot)") }
//            let data = snapshot.data()!
//            for data in data["comments"] {
//
//            }
        }
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
