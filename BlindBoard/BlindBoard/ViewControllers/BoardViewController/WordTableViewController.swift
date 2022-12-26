//
//  BoardTableViewController.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/08/12.
//

import UIKit
import FirebaseFirestore

class WordTableViewController: UITableViewController {
    
    //MARK: - Properties
    
    private var arr: [Word] = []
    
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
        
        self.tableView.register(WordTableViewCell.self, forCellReuseIdentifier: WordTableViewCell.cellIdentifier)
        self.tableView.register(WordHeaderViewController.self, forHeaderFooterViewReuseIdentifier: WordHeaderViewController.cellIdentifier)
        title = "My Word"
        
        fetchBoard()
        
    }
    
    // MARK: - Actions
    
    @objc func writing() {
        let AddBoardViewControl = AddWordViewController()
        AddBoardViewControl.delegate = self
        present(AddBoardViewControl, animated: true)
    }
    
    @objc func updateData() {
        refreshControl?.endRefreshing()
        fetchBoard()
    }
    
    // MARK: - Helpers
    
    func fetchBoard() {
        loadData { [weak self] boards in
            self?.arr = boards
            self?.tableView.reloadData()
        }
    }
    
    func loadData(completion: @escaping([Word]) -> Void) {
        FirebaseConstant.COLLECTION_BOARD.order(by: "writtenTime", descending: true).getDocuments { snapshot, error in
            if let error = error {
                print("Load ERR!!! \(error)")
            }
            guard let documents = snapshot?.documents else { return print("snapshot ERR!!") }
            
            let documentsDone = documents.map { Word(dictionary: $0.data()) }
            completion(documentsDone)
        }
    }
    
}

// MARK: - UITableViewDataSource

extension WordTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
}

// MARK: - UITableViewDelegate

extension WordTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 상세 페이지로 넘어가기
        navigationController?.pushViewController(DetailViewController(board: arr[indexPath.item]), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WordTableViewCell.cellIdentifier, for: indexPath) as? WordTableViewCell else { return UITableViewCell() }
        cell.viewModel = WordViewModel(board: arr[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: WordHeaderViewController.cellIdentifier) as? WordHeaderViewController else { return UIView() }
        header.configureUI()
        header.delegate = self
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let width = view.frame.width
        let height = width / 3
        return CGFloat(height)
    }
    
}

// MARK: - AddDelegate

extension WordTableViewController: AddDelegate {
    func addContent(word: Word) {
        ImageService.imagesFetch(word: word.title) { image in
            if image == UIImage() {
                self.showLoader(false)
                return
            }
            ImageUploader.imageUpload(image: image) { imageUrl in
                FirebaseConstant.COLLECTION_BOARD.document(word.uid).setData(["testTitle": word.title, "textContent": word.content, "writtenTime": Date().ISO8601Format(), "uid": word.uid, "imageUrl": imageUrl[0], "imageFileName" : imageUrl[1]])
                self.dismiss(animated: true)
                self.fetchBoard()
                self.showLoader(false)
            }
        }
    }
    
}

// MARK: - TestStart

extension WordTableViewController: TestStart {
    func testStart() {
        navigationController?.pushViewController(TestViewController(), animated: true)
    }
}
