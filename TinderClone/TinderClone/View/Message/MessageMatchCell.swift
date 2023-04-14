//
//  MatchCell.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/14.
//

import UIKit

class MessageMatchCell: UICollectionViewCell {
    
    var viewModel: MessageMatchCellViewModel? {
        didSet {
            setMatchedUserData()
        }
    }
    
    // MARK: - Properties
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.setDimensions(height: 80, width: 80)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 80 / 2
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0 // 유동적으로 변하게
        return label
    }()
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, userNameLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 6
        addSubview(stack)
        stack.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    
    func setMatchedUserData() {
        guard let viewModel = viewModel else { return }
        userNameLabel.text = viewModel.nameText
        profileImageView.sd_setImage(with: viewModel.profileImageURL)
    }

}
