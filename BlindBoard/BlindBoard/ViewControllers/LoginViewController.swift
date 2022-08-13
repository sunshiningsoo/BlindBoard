//
//  ViewController.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/08/11.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - properties
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.text = "Blind Board⌨"
        title.font = .systemFont(ofSize: 28, weight: .bold)
        return title
    }()
    
    private lazy var idTextfield: UITextField = {
        let text = UITextField()
        text.placeholder = "아이디를 입력하세요."
        text.layer.cornerRadius = 5
        text.backgroundColor = .lightGray
        text.addLeftPadding()
        text.clearButtonMode = .whileEditing
        return text
    }()
    
    private lazy var passwordTextfield: UITextField = {
        let text = UITextField()
        text.placeholder = "비밀번호를 입력하세요."
        text.layer.cornerRadius = 5
        text.backgroundColor = .lightGray
        text.addLeftPadding()
        text.clearButtonMode = .whileEditing
        return text
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(goToBoardView), for: .touchUpInside)
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        return button
    }()
    
    @objc
    func goToBoardView() {
        let vc = BoardTableViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }

    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = .systemBackground
    }
    
    private func render() {
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.topAnchor, paddingTop: 200)
        titleLabel.centerX(inView: view)
        
        view.addSubview(idTextfield)
        idTextfield.anchor(top: titleLabel.bottomAnchor, paddingTop: 100, width: view.bounds.width - 100, height: 50)
        idTextfield.centerX(inView: view)
        
        view.addSubview(passwordTextfield)
        passwordTextfield.anchor(top: idTextfield.bottomAnchor, paddingTop: 30, width: view.bounds.width - 100, height: 50)
        passwordTextfield.centerX(inView: view)
        
        view.addSubview(loginButton)
        loginButton.anchor(top: passwordTextfield.bottomAnchor, paddingTop: 100, width: view.bounds.width - 100, height: 60)
        loginButton.centerX(inView: view)
        
        view.addSubview(registerButton)
        registerButton.anchor(top: loginButton.bottomAnchor, paddingTop: 30, width: view.bounds.width - 100, height: 60)
        registerButton.centerX(inView: view)
    }

}
