//
//  CustomTextField.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/09/21.
//

import UIKit

class CustomTextField: UITextField {

    init(placeholder: String) {
        super.init(frame: .zero)
        
        self.placeholder = placeholder
        self.clearButtonMode = .whileEditing
        addLeftPadding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
