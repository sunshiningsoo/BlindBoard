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
    let AddBoardViewControl = AddBoardViewController()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(updateData), for: .valueChanged)
        tableView.refreshControl = refresher
                
        // navigation back bar hide
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(writing))
        self.tableView.register(BoardTableViewCell.self, forCellReuseIdentifier: BoardTableViewCell.cellIdentifier)
        self.tableView.register(BoardHeaderViewController.self, forHeaderFooterViewReuseIdentifier: BoardHeaderViewController.cellIdentifier)
        title = "Blind Board⌨️"
        
        fetchBoard()
        AddBoardViewControl.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Actions
    
    @objc func writing() {
        present(AddBoardViewControl, animated: true)
    }
    
    @objc func updateData() {
        // update the data from firebase
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
        FirebaseConstant.FIRESTORE.order(by: "writtenTime", descending: true).getDocuments { snapshot, error in
            if let error = error {
                print("Load ERR!!! \(error)")
            }
            guard let documents = snapshot?.documents else { return print("snapshot ERR!!") }
            
            let documentsDone = documents.map { Board(dictionary: $0.data()) }
            completion(documentsDone)
        }
    }

    // MARK: - Datasource, Delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BoardTableViewCell.cellIdentifier, for: indexPath) as? BoardTableViewCell else { return UITableViewCell() }
//        if !arr.isEmpty {
            cell.set(arr[indexPath.row])
//        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: BoardHeaderViewController.cellIdentifier) as? BoardHeaderViewController else { return UIView() }
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(150)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 상세 페이지로 넘어가기
        navigationController?.pushViewController(DetailViewController(board: arr[indexPath.item]), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

// MARK: - AddDelegate

extension BoardTableViewController: AddDelegate {
    func addContent(board: Board) {
        FirebaseConstant.FIRESTORE.document(board.uid).setData(["testTitle": board.title, "textContent": board.content, "writtenTime": Date().ISO8601Format(), "uid": board.uid])
        fetchBoard() // 글 작성 이후에 바로 업데이트 되어, tableview에서 볼 수 있게 도와줌
    }
    
}
