//
//  Comment.swift
//  WeImg
//
//  Created by lzw on 16/2/12.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class Comment: Mappable {
    var commentId: Int!
    var postId: Int!
    var parentId: Int?
    var content: String!
    var points: Int!
    var author: User!
    var created: NSDate!
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        commentId   <- map["commentId"]
        postId      <- map["postId"]
        parentId    <- map["parentId"]
        content     <- map["content"]
        author      <- map["author"]
        points      <- map["points"]
        created     <- (map["created"], CustomDateTransform())
    }
}
