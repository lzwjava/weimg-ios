//
//  TabBarButton.swift
//  WeImg
//
//  Created by lzw on 16/2/19.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import UIKit

class TabBarButton: UIButton {
    
    override func awakeFromNib() {
        
    }
    
    class func instanceFromNib() -> TabBarButton {
        return UINib(nibName: "TabBarButton", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! TabBarButton
    }
    
}
