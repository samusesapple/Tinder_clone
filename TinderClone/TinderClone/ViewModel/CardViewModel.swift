//
//  CardViewModel.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/02.
//

import UIKit

class CardViewModel {
    
    let user: User
    let imageURLs: [String]
    let userInfoText: NSAttributedString
    
    private var userPhotoIndex = 0
    var index: Int { return userPhotoIndex }
    var imageToShow: UIImage?
    
    var imageURL: URL?
    
    
    init(user: User) {
        self.user = user
                
        let attributedText = NSMutableAttributedString(string: user.name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy), .foregroundColor: UIColor.white])
        attributedText.append(NSMutableAttributedString(string: "  \(user.age)", attributes: [.font: UIFont.systemFont(ofSize: 24), .foregroundColor: UIColor.white]))
        
        userInfoText = attributedText
        
        self.imageURLs = user.imageURLs
        self.imageURL = URL(string: self.imageURLs[0])
    }
    
    func showNextPhoto() {
                guard userPhotoIndex < imageURLs.count - 1 else { return }
        userPhotoIndex += 1
        imageURL = URL(string: imageURLs[userPhotoIndex])
        print("DEBUG: show next Image..")
    }
    
    func showPreviousPhoto() {
        guard userPhotoIndex > 0 else { return }
        userPhotoIndex -= 1
        imageURL = URL(string: imageURLs[userPhotoIndex])
        print("DEBUG: show previous Image..")
    }
    
}
