//
//  User.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/02.
//

import UIKit

struct User {
    var name: String
    var age: Int
    var email: String
    let uid: String
    var imageURLs: [String]   // 프로필이미지를 변경시, firebase의 기존 프로필 이미지 url 삭제 후 재생성
    var profession: String
    var bio: String
    var minSeekingAge: Int
    var maxSeekingAge: Int
    
    // Firebase-database에 있는 Dictionary 형식의 유저 데이터를 받아서 User구조체 초기화 하는 생성자
    init(dictionary: [String: Any]) {
        self.name = dictionary["fullName"] as? String ?? ""
        self.age = dictionary["age"] as? Int ?? 0
        self.email = dictionary["email"] as? String ?? ""
        self.imageURLs = dictionary["imageURLs"] as? [String] ?? [String]()
        self.uid = dictionary["uid"] as? String ?? ""
        self.profession = dictionary["profession"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int ?? 18
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int ?? 60
    }
    
}
