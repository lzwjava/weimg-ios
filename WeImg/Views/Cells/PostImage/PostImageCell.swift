//
//  PostImageCell.swift
//  WeImg
//
//  Created by lzw on 16/2/9.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import UIKit
import Kingfisher

class PostImageCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    
    var postImage:Image? {
        didSet {
            if let postImage = postImage {
                postImageView.kf_setImageWithURL(NSURL(string: postImage.link)!)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
