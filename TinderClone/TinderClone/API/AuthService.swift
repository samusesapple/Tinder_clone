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

struct AuthService {
    
    static func registerUser(userInfo credentials: AuthCredentials, completion: @escaping ((Error?)) -> Void) {
        Service.uploadImage(image: credentials.profileImage) { imageUrl in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                if let error = error {
                    print("Error - RegisterUser : \(error.localizedDescription)")
                    return
                }
                guard let userUID = result?.user.uid else { return }
                
                let data = ["email": credentials.email,
                            "fullName": credentials.fullName,
                            "imageURL": imageUrl,
                            "uid": userUID,
                            "age": 18] as [String : Any]
                
                Firestore.firestore().collection("users").document(userUID).setData(data, completion: completion)
            }
            
        }
        
    }
    
}
