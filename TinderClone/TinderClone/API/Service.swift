//
//  Service.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/05.
//

import Foundation
import Firebase

struct Service {
    
// MARK: - [READ]
    // Firestore - users: 특정 UID에 해당되는 유저의 데이터 받기
    static func fetchUser(withUID uid: String, completion: @escaping (User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dataDictionary = snapshot?.data() else { return }
            let user = User.init(dictionary: dataDictionary)
            completion(user)
        }
    }
    
    // Firestore - swipes: 데이터 가져오기
   private static func fetchSwipes(completion: @escaping([String: Bool]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_SWIPES.document(uid).getDocument { snapshot, error in
            guard let data = snapshot?.data() as? [String: Bool] else {
                completion([String : Bool]())
                return }
            
            completion(data)
        }
    }
    
    // Firestore - users: '접속된 유저 기준' swipe 안된 모든 유저의 데이터 가져오기
    static func fetchWholeUsers(forCurrentUser user: User, completion: @escaping ([User]) -> Void) {
        var users = [User]()
        
        let query = COLLECTION_USERS
                .whereField("age", isGreaterThan: user.minSeekingAge - 1)
                .whereField("age", isLessThan: user.maxSeekingAge + 1)
        
        fetchSwipes { swipedUserIDs in
            query.getDocuments { snapshot, error in
                guard let snapshot = snapshot else { return }
                snapshot.documents.forEach({ document in
                    let dictionary = document.data()
                    let user = User(dictionary: dictionary)
                    
                    guard user.uid != Auth.auth().currentUser?.uid else { return }
                    guard swipedUserIDs[user.uid] == nil else { return }
                    users.append(user)
                    
                })
                completion(users)
            }
        }
    }
    
    // Firestore - swipes: 상대 유저 uid의 document 읽어서, 현재 유저에 해당되는 swipe데이터 유무 확인
    static func checkIfMatchExists(forUser user: User, completion: @escaping(Bool) -> Void) {
        // 현재 접속된 유저의 uid
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // '상대방 uid'로 상대방 스냅샷 데이터 받기
        COLLECTION_SWIPES.document(user.uid).getDocument { snapshot, error in
            guard error == nil else { return }
            
            // 데이터 있는지 확인
            guard let data = snapshot?.data() else { return }
            // 상대방 데이터에 접속된 유저의 uid에 해당되는 swipe데이터 -> Bool타입캐스팅해서 받기 (ture/false)
            guard let didMatch = data[currentUid] as? Bool else { return }
            if didMatch == true {
                completion(didMatch)
            }
        }
    }
    
    // Firestore - matches_messages: 현재 유저와 매칭된 모든 유저의 데이터를 받아와서 Match 데이터 모델에 담기
    static func fetchMatches(completion: @escaping ([Match]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
//        var matches = [Match]()
        
        COLLECTION_MATCHES_MESSAGES.document(uid).collection("matches").getDocuments { snapshot, error in
            guard let data = snapshot else { return }
            
            let matches = data.documents.map({ Match(dictionary: $0.data()) })
            completion(matches)
            
            // 참고용 같은 방법
//            data.documents.forEach { documents in
//                let matchData = Match(dictionary: documents.data())
//                matches.append(matchData)
//            } completion(matches)
        }
    }
    
// MARK: - [CREATE]
    // Firebase - storage: 이미지 데이터를 url로 변형시켜 올리기
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
    
    
    // Firestore - swipes: swipe 데이터 유무 확인 후 분기처리
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
    

    // Firestore - matches: 매칭 정보에 관한 데이터 생성
    static func uploadMatch(currentUser: User, matchedUser: User) {
        guard let matchedUserProfileImageURL = matchedUser.imageURLs.first else { return}
        guard let currentUserProfileImageURL = currentUser.imageURLs.first else { return }
        
        let matchedUserData = ["uid": matchedUser.uid,
                               "name": matchedUser.name,
                               "profileImageURL": matchedUserProfileImageURL]
        // 1. COLLECTION_MATCHES_MESSAGES.document - 'current 유저 uid'로 된 document 생성
        // 2. current 유저의 uid로 된 document - 'matches' 컬렉션 생성
        // 3. 'matches' 컬렉션 - 'matched 유저 uid' document 생성
        // 4. matched 유저 uid document - 'matchedUserData 형식 및 데이터로 matched 유저 정보' 저장
        
        COLLECTION_MATCHES_MESSAGES.document(currentUser.uid).collection("matches").document(matchedUser.uid).setData(matchedUserData)
        
        let currentUserData = ["uid": currentUser.uid,
                               "name": currentUser.name,
                               "profileImageURL": currentUserProfileImageURL]
        
        // 1. COLLECTION_MATCHES_MESSAGES.document - 'matched 유저 uid'로 된 document 생성
        // 2. matched 유저의 uid로 된 document - 'matches' 컬렉션 생성
        // 3. 'matches' 컬렉션 - 'current 유저 uid' document 생성
        // 4. current 유저 uid document - 'currentUserData 형식 및 데이터로 current 유저 정보' 저장
        COLLECTION_MATCHES_MESSAGES.document(matchedUser.uid).collection("matches").document(currentUser.uid).setData(currentUserData)
    }

    
// MARK: - [UPDATE]
    // Firestore - users: 유저의 정보 업데이트, 업로드하기
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
 
}
