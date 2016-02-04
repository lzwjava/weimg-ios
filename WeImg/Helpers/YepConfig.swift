//
//  YepConfig.swift
//  WeImg
//
//  Created by lzw on 16/2/3.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import Foundation
import UIKit

let avatarFadeTransitionDuration: NSTimeInterval = 0.0

class YepConfig {
    
    static let appURLString = "itms-apps://itunes.apple.com/app/id" + "983891256"
    static let termsURLString = "http://privacy.soyep.com"
    
    class func avatarCompressionQuality() -> CGFloat {
        return 0.7
    }
    
    class func verifyCodeLength() -> Int {
        return 4
    }
    
    class func avatarMaxSize() -> CGSize {
        return CGSize(width: 414, height: 414)
    }
    
    class func editProfileAvatarSize() -> CGFloat {
        return 100
    }
    
    struct Settings {
        static let userCellAvatarSize: CGFloat = 80
        
        static let introFont: UIFont = {
            if #available(iOS 8.2, *) {
                return UIFont.systemFontOfSize(12, weight: UIFontWeightLight)
            } else {
                return UIFont(name: "HelveticaNeue-Light", size: 12)!
            }
        }()
        
        static let introInset: CGFloat = 20 + userCellAvatarSize + 20 + 10 + 11 + 20
    }
    
    
    struct EditProfile {
        
        static let introFont: UIFont = {
            if #available(iOS 8.2, *) {
                return UIFont.systemFontOfSize(15, weight: UIFontWeightLight)
            } else {
                return UIFont(name: "HelveticaNeue-Light", size: 15)!
            }
        }()
        
        static let introInset: CGFloat = 20 + 20
    }
    
    struct Profile {
        static let leftEdgeInset: CGFloat = Ruler.iPhoneHorizontal(20, 38, 40).value
        static let rightEdgeInset: CGFloat = leftEdgeInset
        static let introductionLabelFont = UIFont.systemFontOfSize(14)
    }
}