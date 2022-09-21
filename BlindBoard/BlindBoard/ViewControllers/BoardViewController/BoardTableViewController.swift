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
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(updateData), for: .valueChanged)
                
        // navigation back bar hide
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(writing))
        self.tableView.register(BoardTableViewCell.self, forCellReuseIdentifier: BoardTableViewCell.cellIdentifier)
        title = "Blind Board⌨️"
        
        loadData()
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
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Helpers
    func loadData() {
        FirebaseConstant.FIRESTORE.order(by: "writtenTime", descending: true).addSnapshotListener { snapshot, error in
            if let error = error {
                print("Load ERR!!! \(error)")
            }
            self.arr = []
            guard let snapshot = snapshot else { return print("snapshot ERR!!") }
            for shot in snapshot.documents {
                let sh = shot.data()
                if let title = sh["testTitle"] as? String, let content = sh["textContent"] as? String, let comments = sh["comments"] as? [String], let uid = sh["uid"] as? String {
                    let tempBoard = Board(title: title, content: content, comments: comments, uid: uid)
                    self.arr.append(tempBoard)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }
    }

    //MARK: - datasource, delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BoardTableViewCell.cellIdentifier, for: indexPath) as? BoardTableViewCell else { return UITableViewCell() }
        cell.set(arr[indexPath.item])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 상세 페이지로 넘어가기
        navigationController?.pushViewController(DetailViewController(board: arr[indexPath.item]), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

// MARK: - BoardTableViewController AddDelegate
extension BoardTableViewController: AddDelegate {
    func addContent(board: Board) {
        FirebaseConstant.FIRESTORE.document(board.uid).setData(["testTitle": board.title, "textContent": board.content, "writtenTime": Date().ISO8601Format(), "comments": board.comments, "uid": board.uid])
    }
    
}
