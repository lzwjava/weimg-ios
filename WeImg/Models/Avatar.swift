//
//  Avatar.swift
//  WeImg
//
//  Created by lzw on 16/2/5.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class Avatar: Mappable {
    var avatarUrl: String = ""
    var avatarFileName: String = ""
    
    var roundMini: NSData = NSData() // 60
    var roundNano: NSData = NSData() // 40
    
    required init() {
        
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        avatarFileName      <-  map["avatarFileName"]
        avatarUrl           <-  map["avatarUrl"]
        roundMini           <-  map["roundMini"]
        roundNano           <-  map["roundNano"]
    }
    
}
