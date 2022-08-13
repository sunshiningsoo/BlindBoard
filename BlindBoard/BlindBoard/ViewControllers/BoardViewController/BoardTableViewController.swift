//
//  BoardTableViewController.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/08/12.
//

import UIKit


struct Number {
    let name: String
}

class BoardTableViewController: UITableViewController {
    
    //MARK: - properties
    private let arr: [Number] = [Number(name: "This is real story about my life"), Number(name: "2"), Number(name: "3"),Number(name: "This is real story about my life"), Number(name: "2"), Number(name: "3"), Number(name: "This is real story about my life"), Number(name: "2"), Number(name: "3"), Number(name: "This is real story about my life"), Number(name: "2"), Number(name: "3"), Number(name: "This is real story about my life"), Number(name: "2"), Number(name: "3")]
    
    struct BoardTableCell {
        static let cellName = "BoardTableViewCell"
    }


    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(writing))
        self.tableView.register(BoardTableViewCell.self, forCellReuseIdentifier: BoardTableCell.cellName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .systemBackground
        
        // navigation Setting
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = "Bline Board⌨️"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = ""
    }
    
    @objc
    func writing() {
        present(AddBoardViewController(), animated: true)
    }

    //MARK: - datasource, delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BoardTableCell.cellName, for: indexPath) as? BoardTableViewCell else { return UITableViewCell() }
        cell.set(arr[indexPath.item])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 상세 페이지로 넘어가기

        navigationController?.pushViewController(DetailViewController(number: arr[indexPath.item]), animated: true)
    }
    
    
}
