//
//  BoardTableViewController.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/08/12.
//

import UIKit


struct Number {
    let title: String
    let content: String
}

class BoardTableViewController: UITableViewController {
    
    //MARK: - properties
    private var arr: [Number] = [Number(title: "123", content: "1234"), Number(title: "asdfs", content: "Asdfasdf"), Number(title: "123", content: "1234"), Number(title: "asdfs", content: "Asdfasdf"), Number(title: "123", content: "1234"), Number(title: "asdfs", content: "Asdfasdf"), Number(title: "123", content: "1234"), Number(title: "asdfs", content: "Asdfasdf")]

    let vc = AddBoardViewController()
    struct BoardTableCell {
        static let cellName = "BoardTableViewCell"
    }


    @objc func sl() {
        // update the data from firebase
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
        }
    }
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(sl), for: .valueChanged)
                
        // navigation back bar hide
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(writing))
        self.tableView.register(BoardTableViewCell.self, forCellReuseIdentifier: BoardTableCell.cellName)
        title = "Bline Board⌨️"
        
        vc.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        title = ""
    }
    
    @objc
    func writing() {
        present(vc, animated: true)
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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

extension BoardTableViewController: AddDelegate {
    func addContent(number: Number) {
        self.arr.insert(number, at: 0)
        self.tableView.reloadData()
    }
}
