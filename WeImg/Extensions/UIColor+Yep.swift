//
//  UIColor+Yep.swift
//  Yep
//
//  Created by NIX on 15/3/16.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func rgb(red: Int, _ green: Int, _ blue: Int) -> UIColor {
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1)
    }
    
    class func yepGray() -> UIColor {
        return rgb(108, 108, 108)
    }
    
    class func yepGreen() -> UIColor {
        return rgb(57, 196, 66)
    }
    
    class func yepRed() -> UIColor {
        return UIColor.redColor()
    }
    
    class func yepMainColor() -> UIColor {
        return UIColor(red: 23 / 255.0, green: 23 / 255.0, blue: 23 / 255.0, alpha: 1.0)
    }
    
    class func cellBackgroundColor() -> UIColor {
        return rgb(34, 34, 34)
    }
    
    class func yepTintColor() -> UIColor {
        return UIColor(red: 50/255.0, green: 167/255.0, blue: 255/255.0, alpha: 1.0)
//        return UIColor.redColor()
    }
    
    class func yepBarButtonColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    class func yepNavigationBarTintColor() -> UIColor {
        return UIColor(red: 31/255.0, green: 31/255.0, blue: 31/255.0, alpha: 1.0)
    }
    
    class func yepBarTintColor() -> UIColor {
        return UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 0.8)
    }
    
    class func yepMessageColor() -> UIColor {
        return UIColor(red: 64/255.0, green: 64/255.0, blue: 64/255.0, alpha: 1.0)
    }

    class func yepNavgationBarTitleColor() -> UIColor {
        return UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
    }

    class func yepViewBackgroundColor() -> UIColor {
        return UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
    }

    class func yepInputTextColor() -> UIColor {
        return UIColor(red: 0.557, green: 0.557, blue: 0.576, alpha: 1.0)
    }

    class func yepBorderColor() -> UIColor {
        return UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
//        return UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
    }

    class func avatarBackgroundColor() -> UIColor {
        return UIColor(red: 50/255.0, green: 167/255.0, blue: 255/255.0, alpha: 0.3)
    }

    class func leftBubbleTintColor() -> UIColor {
        return UIColor(white: 231 / 255.0, alpha: 1.0)
    }

    class func rightBubbleTintColor() -> UIColor {
        return UIColor.yepTintColor()
    }

    class func leftWaveColor() -> UIColor {
        return UIColor.darkGrayColor().colorWithAlphaComponent(0.2)
    }

    class func rightWaveColor() -> UIColor {
        //return UIColor(white: 0.0, alpha: 0.15)
        return UIColor(red:0.176,  green:0.537,  blue:0.878, alpha:1)
    }

    class func yepDisabledColor() -> UIColor {
        return UIColor(red:0.95, green:0.95, blue:0.95, alpha:1)
    }
    
    class func yepGrayColor() -> UIColor {
        return UIColor(red: 142.0/255.0, green: 142.0/255.0, blue: 147.0/255.0, alpha: 1.0)
    }
    
    class func yepBackgroundColor() -> UIColor {
        return UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1.0)
    }

    class func yepCellSeparatorColor() -> UIColor {
        return UIColor.lightGrayColor().colorWithAlphaComponent(0.3)
    }

    class func yepCellAccessoryImageViewTintColor() -> UIColor {
        return UIColor.lightGrayColor()
    }

    class func yepIconImageViewTintColor() -> UIColor {
        return yepCellAccessoryImageViewTintColor()
    }

    // 反色
    var yep_inverseColor: UIColor {

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return UIColor(red: 1 - red, green: 1 - green, blue: 1 - blue, alpha: alpha)
    }

    // 黑白色
    var yep_binaryColor: UIColor {

        var white: CGFloat = 0
        getWhite(&white, alpha: nil)

        return white > 0.92 ? UIColor.blackColor() : UIColor.whiteColor()
    }

    var yep_profilePrettyColor: UIColor {
        //return yep_inverseColor
        return yep_binaryColor
    }
    
}
