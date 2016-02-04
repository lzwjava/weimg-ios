//
//  User.swift
//  WeImg
//
//  Created by lzw on 16/2/2.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class User : Mappable {
    var userId: String!
    var username: String!
    var mobilePhoneNumber: String!
    var avatarUrl: String!
    var sessionToken: String!
    var created: NSDate!
    var introduction: String!
    
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
