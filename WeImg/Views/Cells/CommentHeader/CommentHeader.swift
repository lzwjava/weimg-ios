//
//  CommentHeader.swift
//  WeImg
//
//  Created by lzw on 16/2/12.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import UIKit

class CommentHeader: UITableViewCell {
    
    var commentCount: Int? {
        didSet {
//            countLabel.text = String(self.commentCount)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let optionsButton = OptionsButton.instanceFromNib()
        var options = [String]()
        options.append("热门评论")
        options.append("最新评论")
        optionsButton.options = options
        addSubview(optionsButton)
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func heightForPost(post: Post?) -> CGFloat {
        return 44
    }

}
