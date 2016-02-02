//
//  Upload.swift
//  WeImg
//
//  Created by lzw on 16/2/1.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import Foundation

import ObjectMapper

class UploadToken : Mappable {
    var bucketUrl: String!
    var imageId: String!
    var uptoken: String!
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        bucketUrl   <-  map["bucketUrl"]
        imageId     <-  map["imageId"]
        uptoken     <-  map["uptoken"]
    }
}
