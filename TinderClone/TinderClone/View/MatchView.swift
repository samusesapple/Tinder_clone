//
//  MatchView.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/12.
//

import UIKit

protocol MatchViewDelegate: AnyObject {
    func sendMessage()
    func keepSwiping()
}

class MatchView: UIView {

    // MARK: - Properties
    
    private let currentUser: User
    private let matchedUser: User
    
    weak var delegate: MatchViewDelegate?
    
    private let matchedImageView: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "itsamatch"))
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let descriptionLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private let currentUserImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "jane1"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    private let matchUserImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "jane1"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    private let sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SEND MESSAGE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(sendMessageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let keepSwipingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("KEEP SWIPING", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(keepSwipingButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    lazy var views = [
        matchedImageView,
        descriptionLabel,
        currentUserImageView,
        matchUserImageView,
        sendMessageButton,
        keepSwipingButton
    ]
    
    // MARK: - Lifecycle
    init(currentUser: User, matchedUser: User) {
        self.currentUser = currentUser
        self.matchedUser = matchedUser
        
        super.init(frame: .zero)
        
        configureBlurView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc func sendMessageButtonTapped() {
        delegate?.sendMessage()
    }
    
    @objc func keepSwipingButtonTapped() {
        delegate?.keepSwiping()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        views.forEach { view in
            addSubview(view)
            view.alpha = 1
        }
        
//        matchedImageView.anchor(top: , left: <#T##NSLayoutXAxisAnchor?#>, )
    }
    
    func configureBlurView() {
        addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        visualEffectView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.visualEffectView.alpha = 1
        }
    }
    
}
