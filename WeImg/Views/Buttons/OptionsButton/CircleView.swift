//
//  CircleView.swift
//  WeImg
//
//  Created by lzw on 16/2/15.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import UIKit

class CircleView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    private let selectedColor = UIColor.rgb(57, 196, 66)
    private let normalColor = UIColor.rgb(41, 83, 44)
    
    var selected = false {
        didSet {
            updateColor()
        }
    }
    
    override func awakeFromNib() {
        let size = CGFloat(6)
        layer.cornerRadius = size / 2
        heightAnchor.constraintEqualToConstant(size).active = true
        widthAnchor.constraintEqualToConstant(size).active = true
        updateColor()
    }
    
    private func updateColor() {
        if selected {
            backgroundColor = selectedColor
        } else {
            backgroundColor = normalColor
        }
    }
    
    class func instanceFromNib() -> CircleView {
        return UINib(nibName: "CircleView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! CircleView
    }

}
