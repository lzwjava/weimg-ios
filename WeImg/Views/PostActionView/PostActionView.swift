//
//  PostActionView.swift
//  WeImg
//
//  Created by lzw on 16/2/15.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import UIKit

class PostActionView: UIView {
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.clearColor()
    }
    
    class func instanceFromNib() -> PostActionView {
        return UINib(nibName: "PostActionView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! PostActionView
    }

}
