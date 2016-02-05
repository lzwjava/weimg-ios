//
//  Models.swift
//  WeImg
//
//  Created by lzw on 16/2/5.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import Foundation
import RealmSwift

class Avatar: Object {
    dynamic var avatarUrl: String = ""
    dynamic var avatarFileName: String = ""
    
    dynamic var roundMini: NSData = NSData() // 60
    dynamic var roundNano: NSData = NSData() // 40
    
    var user: User? {
        let users = linkingObjects(User.self, forProperty: "avatar")
        return users.first
    }
}

enum UserFriendState: Int {
    case Normal         = 0   // 正常状态的朋友
    case Me             = 1   // 自己
}

class User: Object {
    dynamic var userId: String = ""
    dynamic var username: String = ""
    dynamic var introduction: String = ""
    dynamic var avatarUrl: String = ""
    dynamic var avatar: Avatar?
    dynamic var mobilePhoneNumber: String = ""
    
    dynamic var created: NSTimeInterval = NSDate().timeIntervalSince1970
    
    dynamic var friendState: Int = UserFriendState.Normal.rawValue
    
    var isMe: Bool {
        if let myUserID = UserManager.currentUser?.userId {
            return userId == myUserID
        }
        
        return false
    }
    
}

func userWithUserID(userID: String, inRealm realm: Realm) -> User? {
    let predicate = NSPredicate(format: "userID = %@", userID)
    
    #if DEBUG
        let users = realm.objects(User).filter(predicate)
        if users.count > 1 {
            println("Warning: same userID: \(users.count), \(userID)")
        }
    #endif
    
    return realm.objects(User).filter(predicate).first
}

func avatarWithAvatarURLString(avatarURLString: String, inRealm realm: Realm) -> Avatar? {
    let predicate = NSPredicate(format: "avatarURLString = %@", avatarURLString)
    return realm.objects(Avatar).filter(predicate).first
}
