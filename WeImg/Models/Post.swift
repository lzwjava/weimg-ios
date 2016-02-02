//
//  Post.swift
//  WeImg
//
//  Created by lzw on 16/1/31.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class Post : Mappable {
    var postId: Int!
    var author: Int!
    var cover: String!
    var score: Float!
    var title: String!
    var topic: String?
    var ups:Int!
    var downs: Int!
    var created: NSDate!
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        postId  <-  map["postId"]
        author  <-  map["author"]
        cover   <-  map["cover"]
        score   <-  map["score"]
        title   <-  map["title"]
        topic   <-  map["topic"]
        ups     <-  map["ups"]
        downs   <-  map["downs"]
        created <-  (map["created"], DateTransform())
    }
}