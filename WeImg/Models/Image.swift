//
//  Image.swift
//  WeImg
//
//  Created by lzw on 16/2/7.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class Image : Mappable {
    var imageId: String!
    var link: String!
    var width: Int!
    var height: Int!
    var author: Int!
    var description: String!
    var created: NSDate!
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        imageId <-  map["imageId"]
        author  <-  map["author"]
        link    <-  map["link"]
        width   <-  map["width"]
        height  <-  map["height"]
        author  <-  map["author"]
        description  <-  map["description"]
        created <-  (map["created"], DateTransform())
    }
}

