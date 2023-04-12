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
    
    // [READ] Firebase-Database에서 특정 UID에 해당되는 유저의 데이터 받기
    static func fetchUser(withUID uid: String, completion: @escaping (User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dataDictionary = snapshot?.data() else { return }
            let user = User.init(dictionary: dataDictionary)
            completion(user)
        }
    }
    
    static func saveSwipe(forUser user: User, isLike: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return}
        
        COLLECTION_SWIPES.document(uid).getDocument { snapshot, error in
            let data = [user.uid: isLike]
            
            if snapshot?.exists == true {
                COLLECTION_SWIPES.document(uid).updateData(data)
            } else {
                COLLECTION_SWIPES.document(uid).setData(data)
            }
        }
    }
    
    static func fetchWholeUsers(completion: @escaping ([User]) -> Void) {
        var users = [User]()
        
        COLLECTION_USERS.getDocuments { snapshot, error in
            snapshot?.documents.forEach({ document in
                let dictionary = document.data()
                let user = User(dictionary: dictionary)
                
                users.append(user)
                if users.count == snapshot?.documents.count {
                    print("fetchWholeUsers() - snapshot.documents.count : \(String(describing: snapshot?.documents.count))")
                    print("fetchWholeUsers() - users array count : \(users.count)")
                    completion(users)
                }
            })
        }
    }
    
    
    // [UPDATE] Firebase-Database에서 유저의 정보 업데이트, 업로드하기
    static func saveUserData(user: User, completion: @escaping(Error?) -> Void) {
        let data = ["uid": user.uid,
                    "fullName": user.name,
                    "imageURLs": user.imageURLs,
                    "age": user.age,
                    "bio": user.bio,
                    "profession": user.profession,
                    "minSeekingAge": user.minSeekingAge, "maxSeekingAge": user.maxSeekingAge] as [String : Any]
        
        COLLECTION_USERS.document(user.uid).setData(data, completion: completion)
    }
 
//    static func updateUserImage(forUser user: User, previousImageURL: String, newImage: UIImage) {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
//            let previousData = ["imageURLs": previousImageURL]
//            if snapshot?.exists == true {
//                COLLECTION_SWIPES.document(uid).updateData(data)
//            } else {
//                COLLECTION_SWIPES.document(uid).setData(data)
//            }
//        }
//    }
}
