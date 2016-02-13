//
//  YepConfig.swift
//  WeImg
//
//  Created by lzw on 16/2/3.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import Foundation
import UIKit
import Ruler

let avatarFadeTransitionDuration: NSTimeInterval = 0.0

class YepConfig {
    
    static let appURLString = "itms-apps://itunes.apple.com/app/id" + "983891256"
    static let termsURLString = "http://privacy.soyep.com"
    
    class func avatarCompressionQuality() -> CGFloat {
        return 0.7
    }
    
    class func imageCompressionQuality() -> CGFloat {
        return 0.8
    }
    
    class func verifyCodeLength() -> Int {
        return 6
    }
    
    class func minPasswordLength() -> Int {
        return 6
    }
    
    class func avatarMaxSize() -> CGSize {
        return CGSize(width: 414, height: 414)
    }
    
    class func editProfileAvatarSize() -> CGFloat {
        return 100
    }
    
    struct Settings {
        static let userCellAvatarSize: CGFloat = 80
    }
    
    struct Profile {
        static let leftEdgeInset: CGFloat = Ruler.iPhoneHorizontal(20, 38, 40).value
        static let rightEdgeInset: CGFloat = leftEdgeInset
    }
    
    struct ChinaSocialNetwork {
        
        struct WeChat {
            
            static let appID = "wx10f099f798871364"
            
            static let sessionType = "com.Catch-Inc.Yep.WeChat.Session"
            static let sessionTitle = NSLocalizedString("WeChat Session", comment: "")
            static let sessionImage = UIImage(named: "wechat_session")!
            
            static let timelineType = "com.Catch-Inc.Yep.WeChat.Timeline"
            static let timelineTitle = NSLocalizedString("WeChat Timeline", comment: "")
            static let timelineImage = UIImage(named: "wechat_timeline")!
        }
    }
    
    struct Feedback {
        static let bottomMargin: CGFloat = Ruler.iPhoneVertical(10, 20, 40, 40).value
    }

}