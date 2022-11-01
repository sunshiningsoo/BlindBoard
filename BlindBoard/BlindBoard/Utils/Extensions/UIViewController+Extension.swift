//
//  UIViewController+Extension.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/11/01.
//

import UIKit
import JGProgressHUD

extension UIViewController {
    static let hud = JGProgressHUD(style: .dark)
    
    func showLoader(_ show: Bool) {
        view.endEditing(true)
        
        if show {
            UIViewController.hud.show(in: view)
        } else {
            UIViewController.hud.dismiss(animated: true)
        }
    }
}
