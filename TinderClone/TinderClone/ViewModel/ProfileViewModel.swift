//
//  ProfileViewModel.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/11.
//

import UIKit

struct ProfileViewModel {
    
    private let user: User
    
    let userDetailsAttributedString: NSAttributedString
    let professionString: String
    let bioString: String
    
    var imageURLArray: [URL] {
        return user.imageURLs.map { URL(string: $0)! }
    }
    
    var imageCount: Int {
        return user.imageURLs.count
    }
    
    init(user: User) {
        self.user = user
        
        let attributedText = NSMutableAttributedString(string: user.name, attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .semibold)])
        
        attributedText.append(NSAttributedString(string: "  \(user.age)", attributes: [.font: UIFont.systemFont(ofSize: 22)]))
        userDetailsAttributedString = attributedText
        
        professionString = user.profession
        bioString = user.bio
    }
}
