//
//  MatchView.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/12.
//

import UIKit

protocol MatchViewDelegate: AnyObject {
    func sendMessage(_ view: MatchView, wantsToSendMessageTo user: User)
}

class MatchView: UIView {

    // MARK: - Properties
    
    private let viewModel: MatchViewViewModel
    
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
        label.text = "You and Someone have liked each other!"
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
    
    private let matchedUserImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "kelly2"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    private let sendMessageButton: UIButton = {
        let button = SendMessageButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitle("SEND MESSAGE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(sendMessageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let keepSwipingButton: UIButton = {
        let button = KeepSwipingButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitle("KEEP SWIPING", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleDismissView), for: .touchUpInside)
        return button
    }()
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    lazy var views = [
        matchedImageView,
        descriptionLabel,
        currentUserImageView,
        matchedUserImageView,
        sendMessageButton,
        keepSwipingButton
    ]
    
    // MARK: - Lifecycle
    init(viewModel: MatchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        setUserData()
        
        configureBlurView()
        configureUI()
        configureAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc func sendMessageButtonTapped() {
        delegate?.sendMessage(self, wantsToSendMessageTo: viewModel.matchedUser)
    }
    
    
    @objc func handleDismissView() {
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }

    }
    
    // MARK: - Helpers
    
    func setUserData() {
        descriptionLabel.text = viewModel.matchLabelText
        
        currentUserImageView.sd_setImage(with: viewModel.currentUserImageURL)
        matchedUserImageView.sd_setImage(with: viewModel.matchedUserImageURL)
    }
    
    func configureUI() {
        views.forEach { view in
            addSubview(view)
            view.alpha = 0
        }
        
        currentUserImageView.anchor(right: centerXAnchor, paddingRight: 16)
        currentUserImageView.setDimensions(height: 140, width: 140)
        currentUserImageView.layer.cornerRadius = 140 / 2
        currentUserImageView.centerY(inView: self)
        
        matchedUserImageView.anchor(left: centerXAnchor, paddingLeft: 16)
        matchedUserImageView.setDimensions(height: 140, width: 140)
        matchedUserImageView.layer.cornerRadius = 140 / 2
        matchedUserImageView.centerY(inView: self)
        
        sendMessageButton.anchor(top: currentUserImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 32, paddingLeft: 48, paddingRight: 48)
        sendMessageButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        keepSwipingButton.anchor(top: sendMessageButton.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 48, paddingRight: 48)
        keepSwipingButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        descriptionLabel.anchor(left: leftAnchor, bottom: currentUserImageView.topAnchor, right: rightAnchor, paddingBottom: 32)
        
        matchedImageView.anchor(bottom: descriptionLabel.topAnchor, paddingBottom: 16)
        matchedImageView.setDimensions(height: 80, width: 300)
        matchedImageView.centerX(inView: self)
    }
    
    func configureAnimation() {
        views.forEach { $0.alpha = 1 }
        
        let angle = 30 * CGFloat.pi / 180
        
        currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: 200, y: 0))
        
        matchedUserImageView.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: -200, y: 0))
        
        self.sendMessageButton.transform = CGAffineTransform(translationX: -500, y: 0)
        self.keepSwipingButton.transform = CGAffineTransform(translationX: 500, y: 0)
        
        UIView.animateKeyframes(withDuration: 1.3, delay: 0, options: .calculationModeCubic) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45) {
                self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
                self.matchedUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                self.currentUserImageView.transform = .identity
                self.matchedUserImageView.transform = .identity
            }
        }
        
        UIView.animate(withDuration: 0.75, delay: 0.5 * 1.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut) {
            self.sendMessageButton.transform = .identity
            self.keepSwipingButton.transform = .identity
        }
    }
    
    func configureBlurView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissView))
        visualEffectView.addGestureRecognizer(tap)
        
        addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        visualEffectView.alpha = 0
        
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.visualEffectView.alpha = 1
        }
    }
    
}
