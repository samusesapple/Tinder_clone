//
//  ProfileCell.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/09.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    
    let imageView =  UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFill
        
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
