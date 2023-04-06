//
//  CardViewModel.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/02.
//

import UIKit

class CardViewModel {
    
    let user: User
    let userInfoText: NSAttributedString
    var userPhotoIndex = 0
    var imageToShow: UIImage?
    
    let imageURL: URL?
    
    
    init(user: User) {
        self.user = user
                
        let attributedText = NSMutableAttributedString(string: user.name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy), .foregroundColor: UIColor.white])
        attributedText.append(NSMutableAttributedString(string: "  \(user.age)", attributes: [.font: UIFont.systemFont(ofSize: 24), .foregroundColor: UIColor.white]))
        
        userInfoText = attributedText
        self.imageURL = URL(string: user.profileImageURL)
        
    }
    
    func showNextPhoto() {
        //        guard userPhotoIndex < user.images.count - 1 else { return }
        userPhotoIndex += 1
        //        imageToShow = user.images[userPhotoIndex]
        print("DEBUG: show next Image..")
    }
    
    func showPreviousPhoto() {
        guard userPhotoIndex > 0 else { return }
        userPhotoIndex -= 1
        //        imageToShow = user.images[userPhotoIndex]
        print("DEBUG: show previous Image..")
    }
    
}
