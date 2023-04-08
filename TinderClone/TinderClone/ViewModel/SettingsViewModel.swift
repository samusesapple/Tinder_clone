//
//  SettingsViewModel.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/07.
//

import Foundation

// settingView의 section을 기준으로 case 나누기
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
    private let user: User
    let section: SettingsSection
    
    // 값이 없는 경우 띄울 placeholderText
    let placeholderText: String
    // 값이 있는 경우 띄울 userInfoValue
    var userInfoValue: String?
    
    var shouldHideInputField: Bool {
        return section == .ageRange
    }
    
    var shouldHideSlider: Bool {
        return section != .ageRange
    }
    
    var minAgeSliderValue: Float {
        return Float(user.minSeekingAge)
    }
    
    var maxAgeSliderValue: Float {
        return Float(user.maxSeekingAge)
    }
    
    func minAgeLabelText(forValue value: Float) -> String {
        return "Min: \(Int(value))"
    }
    
    func maxAgeLabelText(forValue value: Float) -> String {
        return "Max: \(Int(value))"
    }
    
    init(user: User, section: SettingsSection) {
        self.user = user
        self.section = section
        // user데이터가 없을 경우 표시할 placeholderText 세팅하기
        placeholderText = "Enter your \(section.description.lowercased())"
            
        // 초기화 된 user 데이터로 section에 해당되는 userInfoValue 초기화하기
        switch section {
        case .name:
            userInfoValue = user.name
        case .profession:
            userInfoValue = user.profession
        case .age:
            userInfoValue = String(user.age)
        case .bio:
            userInfoValue = user.bio
        case .ageRange:
            break
        }
    }
    
}

