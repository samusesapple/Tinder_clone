//
//  CardView.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/01.
//

import UIKit
import SDWebImage

enum SwipeDirection: Int {
    case left = -1
    case right = 1
}

class CardView: UIView {
    
    // MARK: - Properties
    private let gradientLayer = CAGradientLayer()
    private let barStackView = UIStackView()
    
    var viewModel: CardViewModel
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let infoLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 2

        return label
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "info_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    init(viewModel: CardViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configureGestureRecognizers()
            // url구조체를 사용하여 이미지 캐싱 (매번 같은 이미지 데이터를 받아와야하는 번거로움 해소)
        imageView.sd_setImage(with: viewModel.imageURL)
        
        infoLabel.attributedText = viewModel.userInfoText
        
        layer.cornerRadius = 10
        clipsToBounds = true
        
        addSubview(imageView)
        imageView.fillSuperview()
        configureGradient()
        configureBarStackView()
        
        addSubview(infoLabel)
        infoLabel.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        
        addSubview(infoButton)
        infoButton.setDimensions(height: 40, width: 40)
        infoButton.centerY(inView: infoLabel)
        infoButton.anchor(right: rightAnchor, paddingRight: 16)

    }
    
    // 프레임의 생성이 끝난 후의 시점, 그라데이션을 프레임 기준으로 잡아야함
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            superview?.subviews.forEach({ view in
                view.layer.removeAllAnimations()
            })
        case .changed:
            panCard(sender: sender)
        case .ended:
            resetCardPosition(sender: sender)
        default: break
        }
    }
    
    @objc func handleChangePhoto(sender: UITapGestureRecognizer) {
        let location = sender.location(in: nil).x
        let shouldShowNextPhoto = location > self.frame.width / 2
        
        if shouldShowNextPhoto {
            viewModel.showNextPhoto()
        } else {
            viewModel.showPreviousPhoto()
        }
        
//        imageView.image = viewModel.imageToShow
        imageView.sd_setImage(with: viewModel.imageURL)
        
        barStackView.arrangedSubviews.forEach { $0.backgroundColor = .barDeselectedColor }
        barStackView.arrangedSubviews[viewModel.index].backgroundColor = .white
    }
    
    
    // MARK: - Helpers
    
    func configureGradient() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        layer.addSublayer(gradientLayer)
    }
    
    func configureGestureRecognizers() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleChangePhoto))
        addGestureRecognizer(tap)
    }
    
    func panCard(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 100
        let rotationalTransform = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransform.translatedBy(x: translation.x, y: translation.y)
    }
    
    func resetCardPosition(sender: UIPanGestureRecognizer) {
        let direction: SwipeDirection = sender.translation(in: nil).x > 100 ? .right : .left
        let shouldDismissCard = abs(sender.translation(in: nil).x) > 100
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if shouldDismissCard { // 많이 옆으로 swipe하면,
                let xTransition = CGFloat(direction.rawValue) * 1000
                let offScreenTransform = self.transform.translatedBy(x: xTransition, y: 0)
                self.transform = offScreenTransform
            } else {
                self.transform = .identity
            }
        }) { _ in
            if shouldDismissCard {
                self.removeFromSuperview()
            }
        }
    }

    func configureBarStackView() {
        (0..<viewModel.imageURLs.count).forEach { _ in
            let barView = UIView()
            barView.backgroundColor = .barDeselectedColor
            barStackView.addArrangedSubview(barView)
        }
        barStackView.arrangedSubviews.first?.backgroundColor = .white
        
        addSubview(barStackView)
        barStackView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8, height: 4)
        
        barStackView.spacing = 4
        barStackView.distribution = .fillEqually
    }
    
}
