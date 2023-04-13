//
//  AllService.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/05.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let fullName: String
    let password: String
    let profileImage: UIImage
}

typealias AuthDataResultCallback = (AuthDataResult?, Error?) -> Void

struct AuthService {
    
    static func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(userInfo credentials: AuthCredentials, completion: @escaping ((Error?)) -> Void) {
        Service.uploadImage(image: credentials.profileImage, index: 0) { imageUrl in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                if let error = error {
                    print("Error - RegisterUser : \(error.localizedDescription)")
                    return
                }
                guard let userUID = result?.user.uid else { return }
                
                let data = ["email": credentials.email,
                            "fullName": credentials.fullName,
                            "imageURLs": [imageUrl],
                            "uid": userUID,
                            "age": 18] as [String : Any]
                
                COLLECTION_USERS.document(userUID).setData(data, completion: completion)
            }
            
        }
        
    }
    
}
