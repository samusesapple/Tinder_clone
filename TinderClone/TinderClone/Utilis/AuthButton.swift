//
//  AuthButton.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/04.
//

import UIKit

class AuthButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        layer.cornerRadius = 5
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        setTitleColor(.white, for: .normal)
        isEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
