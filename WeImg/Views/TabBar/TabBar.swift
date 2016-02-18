//
//  TabBar.swift
//  WeImg
//
//  Created by lzw on 16/2/19.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import UIKit

class TabBar: UITabBar {
    
    var tabBarBtn = TabBarButton.instanceFromNib()
    
    override func awakeFromNib() {
        self.addSubview(tabBarBtn)
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tabBarBtn.center = CGPointMake(CGRectGetWidth(bounds) / 2, CGRectGetHeight(bounds) / 2)
        self.bringSubviewToFront(tabBarBtn)
    }
    
}
