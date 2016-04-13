//
//  CommentAccessoryView.swift
//  WeImg
//
//  Created by lzw on 16/2/20.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import UIKit

class CommentAccessoryView: UIView {
    
    var sendAction:(() -> Void)?
    
    override func awakeFromNib() {
        
    }
    
    class func instanceFromNib() -> CommentAccessoryView {
        return UINib(nibName: "CommentAccessoryView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! CommentAccessoryView
    }
    
    @IBAction func sendButtonClicked(sender: AnyObject) {
        sendAction?()
    }
}
