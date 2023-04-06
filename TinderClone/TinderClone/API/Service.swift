//
//  Service.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/05.
//

import Foundation
import Firebase

struct Service {
    // [Create] 이미지 데이터를 url로 변형시켜 Firebase에 올리기
    static func uploadImage(image: UIImage, completion: @escaping (String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let fileName = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(fileName)")
            
        ref.putData(imageData, metadata: nil) {(metaData, error) in
            if let error = error {
                print("uploadImage - \(error.localizedDescription)")
                return
            }
            ref.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
    
    // [READ] UID를 갖고 Firebase-Database에 있는 유저의 데이터 받기
    static func fetchUser(withUID uid: String, completion: @escaping (User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dataDictionary = snapshot?.data() else { return }
            let user = User.init(dictionary: dataDictionary)
            completion(user)
        }
    }
    
    
}
