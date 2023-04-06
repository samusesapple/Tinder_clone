//
//  CustomTextField.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/04.
//

import UIKit

class CustomTextField: UITextField {

    init(placeholder: String, isSecuredText: Bool? = false) {
        super.init(frame: .zero)
        
         let space = UIView()
         space.setDimensions(height: 50, width: 12)
         leftView = space
         leftViewMode = .always
         borderStyle = .none
         textColor = .white
        keyboardAppearance = .dark
         backgroundColor = UIColor(white: 1, alpha: 0.2)
        heightAnchor.constraint(equalToConstant: 50).isActive = true
         layer.cornerRadius = 5
         attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)])
        isSecureTextEntry = isSecuredText!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
