//
//  PostsNavigationBarView.swift
//  WeImg
//
//  Created by lzw on 16/2/20.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import UIKit

class PostsNavigationBarView: UIView {
    
    var optionsButton = OptionsButton.instanceFromNib()
    
    override func awakeFromNib() {
        backgroundColor = UIColor.clearColor()
        
        addSubview(optionsButton)
    }
    
    func setUpWithNavigationFrame(frame: CGRect) {
        self.frame = frame
        let optionsFrame = optionsButton.frame
        optionsButton.frame = CGRectMake(0, 0, optionsFrame.width, frame.height)
    }
    
    class func instanceFromNib() -> PostsNavigationBarView {
        return UINib(nibName: "PostsNavigationBarView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! PostsNavigationBarView
    }
    
}
