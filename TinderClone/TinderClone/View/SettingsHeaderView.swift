//
//  SettingsHeader.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/07.
//

import UIKit

protocol SettingsHeaderViewDelegate: AnyObject {
    func settingsHeaderImageTapped(_ header: SettingsHeaderView, didSelect index: Int)
    
}

class SettingsHeaderView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: SettingsHeaderViewDelegate?
    
    var buttonsArray = [UIButton]()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGroupedBackground
        
        buttonsArray.append(createButton(0))
        buttonsArray.append(createButton(1))
        buttonsArray.append(createButton(2))
        
        addSubview(buttonsArray[0])
        buttonsArray[0].anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16)
        buttonsArray[0].widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45).isActive = true
        
        let buttonStack = UIStackView(arrangedSubviews: [buttonsArray[1], buttonsArray[2]])
        buttonStack.axis = .vertical
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 16
        
        addSubview(buttonStack)
        buttonStack.anchor(top: topAnchor, left: buttonsArray[0].rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Actions
    
    @objc func photoButtonTapped(sender: UIButton) {
        delegate?.settingsHeaderImageTapped(self, didSelect: sender.tag)
    }
    
    // MARK: - Helpers
    
    func createButton(_ index: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        button.tag = index
        return button
    }
    
    
}
