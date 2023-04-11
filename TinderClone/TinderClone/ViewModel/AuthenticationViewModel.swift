//
//  AuthenticationViewModel.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/05.
//

import Foundation

protocol AuthenticationProtocol {
    var formIsValid: Bool { get }
}

struct LoginViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false 
    }
}


struct RegistrationViewModel {
    var email: String?
    var userFullName: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && userFullName?.isEmpty == false && password?.isEmpty == false 
    }
}

