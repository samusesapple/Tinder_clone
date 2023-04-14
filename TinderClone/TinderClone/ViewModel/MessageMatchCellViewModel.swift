//
//  MessageCellMatchViewModel.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/14.
//

import Foundation

struct MessageMatchCellViewModel {
    
    let nameText: String
    let profileImageURL: URL?
    let uid: String
    
    init(match: Match) {
        self.nameText = match.name
        self.profileImageURL = URL(string:match.profileImageURL)!
        self.uid = match.uid
    }
}
