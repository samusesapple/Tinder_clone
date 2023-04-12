//
//  MatchView.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/12.
//

import UIKit

class MatchView: UIView {

    private let currentUser: User
    private let matchedUser: User
    
    // MARK: - Lifecycle
    init(currentUser: User, matchedUser: User) {
        self.currentUser = currentUser
        self.matchedUser = matchedUser
        
        super.init(frame: .zero)
        
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
}
