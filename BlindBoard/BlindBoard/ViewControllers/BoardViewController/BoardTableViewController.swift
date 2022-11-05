//
//  BoardTableViewController.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/08/12.
//

import UIKit
import FirebaseFirestore

class BoardTableViewController: UITableViewController {
    
    //MARK: - Properties
    
    private var arr: [Board] = []
    
    //MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .systemBackground
        fetchBoard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(updateData), for: .valueChanged)
        tableView.refreshControl = refresher
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(writing))
        
        self.tableView.register(BoardTableViewCell.self, forCellReuseIdentifier: BoardTableViewCell.cellIdentifier)
        self.tableView.register(BoardHeaderViewController.self, forHeaderFooterViewReuseIdentifier: BoardHeaderViewController.cellIdentifier)
        title = "My Word"
        
        fetchBoard()
        
    }
    
    // MARK: - Actions
    
    @objc func writing() {
        let AddBoardViewControl = AddBoardViewController()
        AddBoardViewControl.delegate = self
        present(AddBoardViewControl, animated: true)
    }
    
    @objc func updateData() {
        refreshControl?.endRefreshing()
        fetchBoard()
    }
    
    // MARK: - Helpers
    
    func fetchBoard() {
        loadData { boards in
            self.arr = boards
            self.tableView.reloadData()
        }
    }
    
    func loadData(completion: @escaping([Board]) -> Void) {
        FirebaseConstant.COLLECTION_BOARD.order(by: "writtenTime", descending: true).getDocuments { snapshot, error in
            if let error = error {
                print("Load ERR!!! \(error)")
            }
            guard let documents = snapshot?.documents else { return print("snapshot ERR!!") }
            
            let documentsDone = documents.map { Board(dictionary: $0.data()) }
            completion(documentsDone)
        }
    }
    
}

// MARK: - UITableViewDataSource

extension BoardTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
}

// MARK: - UITableViewDelegate

extension BoardTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 상세 페이지로 넘어가기
        navigationController?.pushViewController(DetailViewController(board: arr[indexPath.item]), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BoardTableViewCell.cellIdentifier, for: indexPath) as? BoardTableViewCell else { return UITableViewCell() }
        cell.viewModel = BoardViewModel(board: arr[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: BoardHeaderViewController.cellIdentifier) as? BoardHeaderViewController else { return UIView() }
        header.configureUI()
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let width = view.frame.width
        let height = width / 3
        return CGFloat(height)
    }
    
}

// MARK: - AddDelegate

extension BoardTableViewController: AddDelegate {
    func addContent(board: Board) {
        ImageService.imagesFetch(word: board.title) { image in
            if image == UIImage() {
                self.showLoader(false)
                return
            }
            ImageUploader.imageUpload(image: image) { imageUrl in
                FirebaseConstant.COLLECTION_BOARD.document(board.uid).setData(["testTitle": board.title, "textContent": board.content, "writtenTime": Date().ISO8601Format(), "uid": board.uid, "imageUrl": imageUrl[0], "imageFileName" : imageUrl[1]])
                self.dismiss(animated: true)
                self.fetchBoard()
                self.showLoader(false)
            }
        }
    }
    
}
