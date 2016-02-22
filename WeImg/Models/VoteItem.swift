//
//  VoteItem.swift
//  WeImg
//
//  Created by lzw on 16/2/23.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import UIKit
import ObjectMapper

class VoteItem: Mappable {
    var vote: String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        vote <- map["vote"]
    }
}
