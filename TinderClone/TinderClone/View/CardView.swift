//
//  CardView.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/01.
//

import UIKit

class CardView: UIView {
    
    // MARK: - Properties
    private let gradientLayer = CAGradientLayer()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "jane3")
        return iv
    }()
    
    private let infoLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 2
        
        let attributedText = NSMutableAttributedString(string: "Jane Doe", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy), .foregroundColor: UIColor.white])
        attributedText.append(NSMutableAttributedString(string: "  21", attributes: [.font: UIFont.systemFont(ofSize: 24), .foregroundColor: UIColor.white]))
        label.attributedText = attributedText
        return label
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "info_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemMint
        layer.cornerRadius = 10
        clipsToBounds = true
        
        addSubview(imageView)
        imageView.fillSuperview()
        configureGradient()
        
        addSubview(infoLabel)
        infoLabel.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        
        addSubview(infoButton)
        infoButton.setDimensions(height: 40, width: 40)
        infoButton.centerY(inView: infoLabel)
        infoButton.anchor(right: rightAnchor, paddingRight: 16)
        
        configureGestureRecognizers()
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
            print("DEBUG: Pan did begin")
        case .changed:
            panCard(sender: sender)
        case .ended:
            resetCardPosition(sender: sender)
        default: break
        }
    }
    @objc func handleChangePhoto(sender: UITapGestureRecognizer) {
        print("Photo Tapped")
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
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.transform = .identity
        }) { _ in
            print("DEBUG: Animation did complete")
        }
    }

}
