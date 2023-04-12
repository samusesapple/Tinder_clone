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
    
    // like 여부 저장 후, 쌍방향 like인지 체크
    static func saveSwipe(forUser user: User, isLike: Bool, completion: ((Error?) -> Void)?) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // 현재 접속중인 유저 데이터에 [상대방uid : isLike] 형태로 된 데이터
        COLLECTION_SWIPES.document(uid).getDocument { snapshot, error in
            let data = [user.uid: isLike]
           
            // 해당되는 데이터 존재하면, 업데이트 / 없으면 새로운 데이터 생성
            if snapshot?.exists == true {
                COLLECTION_SWIPES.document(uid).updateData(data, completion: completion)
            } else {
                COLLECTION_SWIPES.document(uid).setData(data, completion: completion)
            }
        }
    }
    
    static func checkIfMatchExists(forUser user: User, completion: @escaping(Bool) -> Void) {
        // 현재 접속된 유저의 uid
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // '상대방 uid'로 상대방 스냅샷 데이터 받기
        COLLECTION_SWIPES.document(user.uid).getDocument { snapshot, error in
            guard error == nil else { return }
            
            // 데이터 있는지 확인
            guard let data = snapshot?.data() else { return }
            // 상대방 데이터에 접속된 유저의 uid에 해당되는 swipe데이터를 -> Bool타입캐스팅해서 받기 (ture/false)
            guard let didMatch = data[currentUid] as? Bool else { return }
            print(didMatch)
            completion(didMatch)
        }
    }
    
    static func fetchWholeUsers(forCurrentUser user: User, completion: @escaping ([User]) -> Void) {
        var users = [User]()
        
        let query = COLLECTION_USERS
                .whereField("age", isGreaterThan: user.minSeekingAge - 1)
                .whereField("age", isLessThan: user.maxSeekingAge + 1)
        
        query.getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            snapshot.documents.forEach({ document in
                let dictionary = document.data()
                let user = User(dictionary: dictionary)
                
                guard user.uid != Auth.auth().currentUser?.uid else { return }
                users.append(user)
                
                if users.count == snapshot.documents.count - 1 {
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
