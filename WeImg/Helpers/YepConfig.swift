//
//  YepConfig.swift
//  WeImg
//
//  Created by lzw on 16/2/3.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import Foundation
import UIKit

class YepConfig {
    
    class func avatarCompressionQuality() -> CGFloat {
        return 0.7
    }
    
    class func verifyCodeLength() -> Int {
        return 4
    }
    
    class func avatarMaxSize() -> CGSize {
        return CGSize(width: 414, height: 414)
    }
}