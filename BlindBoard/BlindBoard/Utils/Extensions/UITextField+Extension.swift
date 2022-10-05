//
//  UITextField+Extension.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/08/12.
//

import UIKit

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
