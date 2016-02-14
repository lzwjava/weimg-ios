//
//  PostTitleView.swift
//  WeImg
//
//  Created by lzw on 16/2/9.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import UIKit
import DateTools

class PostTitleView: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var voteLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var post: Post? {
        didSet {
            self.titleLabel.text = self.post?.title
            self.nameLabel.text = String(self.post?.author)
            self.voteLabel.text = String(self.post?.ups)
            self.timeLabel.text = self.post?.created.timeAgoSinceNow()
//            self.timeLabel.text = self.post?.created
        }
    }
    
    override func awakeFromNib() {
    }
    
    class func heightForPost(post: Post?) -> CGFloat {
        return 73
    }
    
}
