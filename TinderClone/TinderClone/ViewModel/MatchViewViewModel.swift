//
//  MatchViewViewModel.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/13.
//

import Foundation

struct MatchViewViewModel {

    private let currentUser: User
    let matchedUser: User
    
    let matchLabelText: String
    
    var currentUserImageURL: URL?
    var matchedUserImageURL: URL?
    
    init(currentUser: User, matchedUser: User) {
        self.currentUser = currentUser
        self.matchedUser = matchedUser
        
        matchLabelText = "You and \(matchedUser.name) have liked each other!"
        
        guard let currentUserURL = currentUser.imageURLs.first else { return }
        guard let matchedUserURL = matchedUser.imageURLs.first else { return }
        
        currentUserImageURL = URL(string: currentUserURL)
        matchedUserImageURL = URL(string: matchedUserURL)
    }
    
}
