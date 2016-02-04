//
//  UIFont+Yep.swift
//  Yep
//
//  Created by NIX on 15/3/30.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit

extension UIFont {
    class func chatTextFont() -> UIFont {
        return UIFont.systemFontOfSize(16)
    }
    
    class func barButtonFont() -> UIFont {
        return UIFont.systemFontOfSize(14)
    }

    class func navigationBarTitleFont() -> UIFont { // make sure it's the same as system use
        return UIFont.boldSystemFontOfSize(17)
    }

    class func feedMessageFont() -> UIFont {
        return UIFont.systemFontOfSize(17)
    }

    class func feedSkillFont() -> UIFont {
        return UIFont.systemFontOfSize(12)
    }

    class func feedBottomLabelsFont() -> UIFont {
        return UIFont.systemFontOfSize(14)
    }

    class func feedVoiceTimeLengthFont() -> UIFont {
        return UIFont.systemFontOfSize(15)
    }
}
