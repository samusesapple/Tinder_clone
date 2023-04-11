//
//  ButtonStackView.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/03/30.
//

import UIKit

protocol HomeNavigationStackViewDelegate: AnyObject {
    func showSettings()
    func showMessages()
}

class HomeNavigationStackView: UIStackView {
    
    // MARK: - Properties
    
    weak var delegate: HomeNavigationStackViewDelegate?
    let settingsButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    let tinderIcon = UIImageView(image: #imageLiteral(resourceName: "app_icon"))
    

    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        tinderIcon.contentMode = .scaleAspectFit
        
        settingsButton.setImage(#imageLiteral(resourceName: "top_left_profile").withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.setImage(#imageLiteral(resourceName: "top_right_messages").withRenderingMode(.alwaysOriginal), for: .normal)
        
        [settingsButton, UIView(), tinderIcon, UIView(), messageButton].forEach { view in
            addArrangedSubview(view)
        }
        
        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        addActions()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Add Target
    func addActions() {
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        messageButton.addTarget(self, action: #selector(messageButtonTapped), for: .touchUpInside)
    }
    
    @objc func settingsButtonTapped() {
        delegate?.showSettings()
    }
    
    @objc func messageButtonTapped() {
        delegate?.showMessages()
    }
    
}
