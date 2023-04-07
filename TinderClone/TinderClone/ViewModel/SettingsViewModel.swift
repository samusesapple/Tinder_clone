//
//  SettingsViewModel.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/07.
//

import Foundation

enum SettingsSection: Int, CaseIterable {
    case name
    case profession
    case age
    case bio
    case ageRange
    
    var description: String {
        switch self {
            
        case .name:
            return "Name"
        case .profession:
            return "Profession"
        case .age:
            return "Age"
        case .bio:
            return "Bio"
        case .ageRange:
            return "Seeking Age Range"
        }
    }
}

struct SettingsViewModel {
    
    
}
