//
//  User.swift
//  WeImg
//
//  Created by lzw on 16/2/2.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import Foundation
import ObjectMapper

enum UserFriendState: Int {
    case Normal         = 0   // 正常状态的朋友
    case Me             = 1   // 自己
}

class User : Mappable {
    var userId: String!
    var username: String!
    var mobilePhoneNumber: String!
    var avatarUrl: String!
    var sessionToken: String!
    var created: NSDate!
    var introduction: String!
    
    var friendState: UserFriendState {
        if let currnetUser = UserManager.currentUser {
            if currnetUser.userId == self.userId {
                return UserFriendState.Me
            } else {
                return UserFriendState.Normal
            }
        }
        return UserFriendState.Me
    }
    
    var isMe: Bool {
        return friendState == UserFriendState.Me
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        userId              <-  map["userId"]
        username            <-  map["username"]
        mobilePhoneNumber   <-  map["mobilePhoneNumber"]
        avatarUrl           <-  map["avatarUrl"]
        sessionToken        <-  map["sessionToken"]
        introduction        <-  map["introduction"]
        created             <- (map["created"],DateTransform())
    }
    
    
}
